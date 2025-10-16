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
import '../../sales/provider/sales_provider.dart';
import '../../shift/model/shift_session_model.dart';
import '../../shift/provider/shift_provider.dart';
import '../model/cart_extension.dart';
import '../model/cart_state.dart';

part 'cart_provider.g.dart';

abstract class CartAbstract {
  Future<void> createNew({
    required int pax,
    required SalesMode salesMode,
    required UserModel user,
    required OutletState outletState,
  });

  void setSalesAndPax(SalesMode salesMode, int pax);

  Future<void> addProductDirectly(ProductModel product);
  Future<void> upsertCartItem(CartItem item);
  Future<void> removeItem(CartItem item);
  Future<void> clearCurrentItems();

  Future<void> saveBill(String? name);
  Future<void> pay(
    List<CartPayment> payments,
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
  ShiftNotifier get _shiftNotifier => ref.read(shiftProvider.notifier);
  UserModel get _currentUser => ref.read(userProvider).selectedUser;

  @override
  Future<void> createNew({
    required int pax,
    required SalesMode salesMode,
    required UserModel user,
    required OutletState outletState,
  }) async {
    final shift = _shift.requiredOpen;
    final now = DateTime.now().toIso8601String();

    final newCart = CartState(
      id: ObjectId().hexString,
      rc: _shiftNotifier.generateReceiptCode(),
      salesMode: salesMode,
      pax: pax,
      outletId: outletState.outlet.id,
      sessionId: shift.id,
      batches: [
        CartBatch(
          id: 1,
          at: now,
          by: user.id,
        ),
      ],
      createdAt: now,
      createdBy: user.id,
      updatedAt: now,
      updatedBy: user.id,
    );

    state = newCart;
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
      var item = newItems[idx];

      final qty = item.qty + 1;
      final gross = qty * item.price;
      final net = gross;
      item = item.copyWith(
        qty: qty,
        gross: gross,
        net: net,
      );

      newItems[idx] = item;
    } else {
      final price = product.price;

      final item = CartItem(
        id: ObjectId().hexString,
        batchId: state.batchId,
        salesMode: state.salesMode,
        product: CartItemProduct(
          id: product.id,
          name: product.name,
          price: price,
        ),
        variant: null,
        note: '',
        qty: 1,
        price: price,
        gross: price,
        discount: 0,
        net: price,
      );

      newItems.add(item);
    }

    newState = newState.copyWith(items: newItems);
    state = newState.recalculate();
  }

  @override
  Future<void> upsertCartItem(CartItem item) async {
    var newState = state.copyWith();
    final newItems = state.items.toList();

    final idx = newItems.indexWhere((i) => i.id == item.id && i.batchId == item.batchId);
    if (idx != -1) {
      newItems[idx] = item;
    } else {
      newItems.add(item);
    }

    newState = newState.copyWith(items: newItems);
    state = newState.recalculate();
  }

  @override
  Future<void> removeItem(CartItem item) async {
    var newState = state.copyWith();
    final newItems = state.items.toList();
    final idx = newItems.indexWhere((i) => i.id == item.id && i.batchId == item.batchId);
    if (idx != -1) {
      newItems.removeAt(idx);
      newState = newState.copyWith(items: newItems);
      state = newState.recalculate();
    }
  }

  @override
  Future<void> clearCurrentItems() async {
    // Remove all items in current batch
    var newState = state.copyWith();
    final newItems = state.items.where((item) => item.batchId != state.batchId).toList();
    newState = newState.copyWith(items: newItems);
    state = newState.recalculate();
  }

  @override
  void reset() {
    state = CartState();
  }

  @override
  Future<void> pay(List<CartPayment> payments, UserModel user, OutletState outletState) async {
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
      customer: name != null ? CartCustomer(name: name) : state.customer,
    );

    await _shiftNotifier.onSalesSaved(
      cart: newState,
      lastStatus: lastStatus,
    );

    await ref.read(salesProvider.notifier).save(newState);
  }
}
