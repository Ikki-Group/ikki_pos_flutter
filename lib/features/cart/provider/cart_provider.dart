import 'dart:async';

import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_constant.dart';
import '../../auth/model/user_model.dart';
import '../../auth/provider/user_provider.dart';
import '../../outlet/model/outlet_state.dart';
import '../../outlet/provider/outlet_provider.dart';
import '../../printer/provider/printer_provider.dart';
import '../../printer/templates/template_receipt_checker.dart';
import '../../product/model/product_model.dart';
import '../../sales/domain/model/sales_model.dart';
import '../../sales/provider/sales_provider.dart';
import '../../shift/model/shift_session_model.dart';
import '../../shift/provider/shift_provider.dart';
import '../domain/cart_state.dart';

part 'cart_provider.g.dart';

abstract class CartAbstract {
  Future<void> createNew({
    required int pax,
    required SalesMode salesMode,
  });
  Future<void> createNewBatch(
    CartState cart,
  );

  void setSalesAndPax(SalesMode salesMode, int pax);

  Future<void> addProductDirectly(ProductModel product);
  Future<void> upsertCartItem({
    required String id,
    required ProductModel product,
    required SalesItemVariant? variant,
    required int qty,
    required String note,
  });
  Future<void> removeItem(CartItem item);
  Future<void> clearCurrentItems();

  Future<void> saveBill(String? name);
  Future<void> pay(
    List<SalesPayment> payments,
    UserModel user,
    OutletState outletState,
  );

  void reset();
}

@Riverpod(keepAlive: true)
class Cart extends _$Cart implements CartAbstract {
  @override
  CartState build() {
    return CartState();
  }

  ShiftSessionModel? get _shift => ref.read(shiftProvider);
  UserModel get _currentUser => ref.read(userProvider).selectedUser;
  OutletState get _outletState => ref.read(outletProvider);

  ShiftNotifier get _shiftNotifier => ref.read(shiftProvider.notifier);

  @override
  Future<void> createNew({required int pax, required SalesMode salesMode}) async {
    final shift = _shift.requiredOpen;
    final now = DateTime.now().toIso8601String();
    final userId = _currentUser.id;

    final newCart = CartState(
      id: ObjectId().hexString,
      rc: _shiftNotifier.generateReceiptCode(),
      salesMode: salesMode,
      pax: pax,
      outletId: _outletState.outlet.id,
      sessionId: shift.id,
      batches: [
        SalesBatch(
          id: 1,
          at: now,
          by: userId,
        ),
      ],
      createdAt: now,
      createdBy: userId,
      updatedAt: now,
      updatedBy: userId,
    );

    state = newCart;
  }

  @override
  Future<void> createNewBatch(CartState cart) async {
    final batchId = cart.batches.length + 1;
    final userId = _currentUser.id;
    final now = DateTime.now().toIso8601String();

    state = cart.copyWith(
      batchId: batchId,
      batches: [
        ...cart.batches,
        SalesBatch(
          id: batchId,
          at: now,
          by: userId,
        ),
      ],
    );
  }

  @override
  void setSalesAndPax(SalesMode salesMode, int pax) {
    state = state.copyWith(salesMode: salesMode, pax: pax);
  }

  @override
  Future<void> addProductDirectly(ProductModel product) async {
    var newState = state.copyWith();
    final newItems = state.items.toList();

    // Upsert if product already exist
    // Unique by product id, note, batchId and salesMode
    final idx = newItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.batchId == state.batchId &&
          item.salesMode == state.salesMode &&
          item.note.isEmpty,
    );

    if (idx != -1) {
      final item = newItems[idx];
      newItems[idx] = item.copyWith(
        qty: item.qty + 1,
      );
    } else {
      final price = product.price;

      final item = CartItem(
        id: ObjectId().hexString,
        batchId: state.batchId,
        salesMode: state.salesMode,
        product: SalesItemProduct(
          id: product.id,
          name: product.name,
          price: price,
        ),
        variant: null,
        note: '',
        qty: 1,
      );

      newItems.add(item);
    }

    state = newState.copyWith(items: newItems);
  }

  @override
  Future<void> upsertCartItem({
    required String id,
    required ProductModel product,
    required SalesItemVariant? variant,
    required int qty,
    required String note,
  }) async {
    var newState = state.copyWith();
    final newItems = state.items.toList();

    final cartItem = CartItem(
      id: id,
      batchId: newState.batchId,
      salesMode: newState.salesMode,
      product: SalesItemProduct(
        id: product.id,
        name: product.name,
        price: product.price,
      ),
      variant: variant,
      qty: qty,
      note: note,
    );

    final idx = newItems.indexWhere((i) => i.id == id && i.batchId == newState.batchId);
    if (idx.isNegative) {
      newItems.add(cartItem);
    } else {
      newItems[idx] = cartItem;
    }

    state = newState.copyWith(items: newItems);
  }

  @override
  Future<void> removeItem(CartItem item) async {
    var newState = state.copyWith();
    final newItems = state.items.toList();
    final idx = newItems.indexWhere((i) => i.id == item.id && i.batchId == item.batchId);
    if (idx != -1) {
      newItems.removeAt(idx);
      state = newState.copyWith(items: newItems);
    }
  }

  @override
  Future<void> clearCurrentItems() async {
    // Remove all items in current batch
    var newState = state.copyWith();
    final newItems = state.items.where((item) => item.batchId != state.batchId).toList();
    state = newState.copyWith(items: newItems);
  }

  @override
  void reset() {
    state = CartState();
  }

  @override
  Future<void> pay(List<SalesPayment> payments, UserModel user, OutletState outletState) async {
    final outlet = ref.read(outletProvider);
    var newState = state.copyWith();
    newState = newState.copyWith(status: CartStatus.success, payments: payments);

    // await ref
    //     .read(outletProvider.notifier)
    //     .onSavedOrder(
    //       cart: newState,
    //       lastStatus: CartStatus.process,
    //       newPayments: payments,
    //     );

    await ref.read(salesProvider.notifier).save(newState);

    unawaited(ref.read(printerProvider.notifier).print(TemplateReceiptChecker(newState, outlet)));
    // unawaited(ref.read(printerProvider.notifier).print(TemplateReceipt(newState, outlet)));

    state = newState;
  }

  @override
  Future<void> saveBill(String? name) async {
    final lastStatus = state.status;
    final newState = state.copyWith(
      status: CartStatus.process,
      billType: BillType.open,
      updatedAt: DateTime.now().toIso8601String(),
      updatedBy: ref.read(userProvider).selectedUser.id,
      customer: name != null ? SalesCustomer(name: name) : state.customer,
    );

    await _shiftNotifier.onSalesSaved(
      cart: newState,
      lastStatus: lastStatus,
    );

    await ref.read(salesProvider.notifier).save(newState);
  }
}
