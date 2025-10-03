import 'dart:async';

import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../outlet/outlet_model.dart';
import '../outlet/outlet_provider.dart';
import '../outlet/outlet_util.dart';
import '../printer/printer_provider.dart';
import '../printer/templates/template_receipt.dart';
import '../printer/templates/template_receipt_checker.dart';
import '../product/product.model.dart';
import '../sale/sale_enum.dart';
import '../user/user_model.dart';
import '../user/user_provider.dart';
import '../user/user_util.dart';
import 'cart_enum.dart';
import 'cart_extension.dart';
import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_util.dart';

part 'cart_state.g.dart';

abstract class CartAbstract {
  void setCart(Cart cart);
  void setState(Cart Function(Cart) fn);
  void newCart(int pax, SaleMode saleMode, {required UserModel user, required OutletStateModel outletState});
  void setSalesAndPax(SaleMode saleMode, int pax);
  void newBatch(Cart cart, UserModel user);
  void addProductDirectly(ProductModel product);
  void addCartItem(CartItem item);
  void removeItem(CartItem item);
  void clearAllItems();
  void reset();
  void save(String? name);
  void pay(List<CartPayment> payments);
  void print();
}

@Riverpod(keepAlive: true, name: 'cartStateProvider')
class CartState extends _$CartState implements CartAbstract {
  @override
  Cart build() => const Cart();

  @override
  void setCart(Cart cart) => state = cart.copyWith();

  @override
  void setState(Cart Function(Cart) fn) => state = fn(state);

  @override
  void newCart(int pax, SaleMode saleMode, {required UserModel user, required OutletStateModel outletState}) {
    final outlet = outletState.outlet;
    final session = outletState.requireOpen;

    final rc = ref.read(outletProvider.notifier).getReceiptCode();
    final now = DateTime.now().toIso8601String();
    final initialBatch = CartBatch(id: 1, at: now, by: user.id);

    state = Cart(
      id: ObjectId().hexString,
      rc: rc,
      saleMode: saleMode,
      pax: pax,
      outletId: outlet.id,
      sessionId: session.id,
      batches: [initialBatch],
      createdAt: now,
      createdBy: user.id,
      updatedAt: now,
      updatedBy: user.id,
    );
  }

  @override
  void setSalesAndPax(SaleMode saleMode, int pax) {
    state = state.copyWith(saleMode: saleMode, pax: pax);
  }

  @override
  void newBatch(Cart cart, UserModel user) {
    state = cart.copyWith(
      batches: [
        ...state.batches,
        CartBatch(
          id: state.batches.length + 1,
          at: DateTime.now().toIso8601String(),
          by: user.id,
        ),
      ],
      batchId: state.batches.length + 1,
    );
  }

  @override
  void addProductDirectly(ProductModel product) {
    final items = state.items.toList();
    final targetIdx = items.indexWhere((i) => i.product.id == product.id && i.note.isEmpty);

    if (targetIdx != -1) {
      items[targetIdx] = items[targetIdx].changeQty(1);
      state = state.copyWith(items: items);
      _recalculateCart();
    } else {
      final newItem = CartItem(
        id: ObjectId().hexString,
        batchId: state.batchId,
        product: product.toCartItemProduct(),
        price: product.price,
      ).changeQty(1);

      items.add(newItem);
      state = state.copyWith(items: items);
      _recalculateCart();
    }
  }

  @override
  void addCartItem(CartItem item) {
    final items = state.items.toList();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
    } else {
      items.add(item);
    }

    state = state.copyWith(items: items);
    _recalculateCart();
  }

  @override
  void removeItem(CartItem item) {
    final items = state.items.toList();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    items.removeAt(index);
    state = state.copyWith(items: items);
    _recalculateCart();
  }

  @override
  void clearAllItems() {
    state = state.copyWith(
      items: [],
      gross: 0,
      net: 0,
    );
  }

  @override
  void reset() {
    state = const Cart();
  }

  @override
  Future<void> save(String? name) async {
    state = state.copyWith(
      status: CartStatus.process,
      billType: BillType.open,
      updatedAt: DateTime.now().toIso8601String(),
      updatedBy: ref.read(currentUserProvider).requireValue.id,
      customer: name != null ? CartCustomer(name: name) : state.customer,
    );

    await ref.read(cartDataProvider.notifier).save(state);
    await ref.read(outletProvider.notifier).incrementReceiptCode();
    reset();
  }

  @override
  Future<void> pay(List<CartPayment> payments) async {
    final user = _getUser();
    final now = DateTime.now().toIso8601String();

    state = state.copyWith(
      status: CartStatus.success,
      billType: BillType.close,
      updatedAt: now,
      updatedBy: user.id,
      payments: payments,
    );

    await ref.read(cartDataProvider.notifier).save(state);
    await ref.read(outletProvider.notifier).incrementReceiptCode();
    await ref.read(outletProvider.notifier).addSalesSuccess(state.net, state.receivableCash);

    final outlet = ref.read(outletProvider);
    // unawaited(ref.read(printerStateProvider.notifier).print(TemplateReceipt(state, outlet)));
    const copyCount = 2;
    for (var i = 0; i < copyCount; i++) {
      unawaited(ref.read(printerStateProvider.notifier).print(TemplateReceiptChecker(state, outlet)));
    }

    // Reset after screen success
    // reset();
  }

  @override
  void print() {
    unawaited(ref.read(printerStateProvider.notifier).print(TemplateReceipt(state, ref.read(outletProvider))));
  }

  // Internal methods

  UserModel _getUser() {
    return ref.read(currentUserProvider).requireValue;
  }

  void _recalculateCart() {
    final items = state.items;
    final itemsGross = items.fold<double>(0, (sum, item) => sum + item.gross);
    final itemsNet = items.fold<double>(0, (sum, item) => sum + item.net);

    const cartDiscountAmount = 0.0;
    final finalNet = itemsNet - cartDiscountAmount;

    state = state.copyWith(
      discount: cartDiscountAmount,
      gross: itemsGross,
      net: finalNet,
    );
  }
}
