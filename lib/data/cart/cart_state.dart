import 'dart:async';

import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../outlet/outlet_model.dart';
import '../outlet/outlet_provider.dart';
import '../outlet/outlet_util.dart';
import '../printer/printer_provider.dart';
import '../printer/templates/template_receipt.dart';
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

@Riverpod(keepAlive: true, name: 'cartStateProvider')
class CartState extends _$CartState {
  @override
  Cart build() => const Cart();

  void setCart(Cart cart) => state = cart.copyWith();

  void setState(Cart Function(Cart) fn) => state = fn(state);

  Future<void> newCart({
    required int pax,
    required SaleMode saleMode,
    required OutletStateModel outletState,
    required UserModel user,
  }) async {
    final outlet = outletState.outlet;
    final session = outletState.requireOpen;

    final rc = ref.read(outletProvider.notifier).getReceiptCode();
    final now = DateTime.now().toIso8601String();
    final initialLog = CartLogAction.create.toLog(state, user, 'Cart created');
    final initialBatch = CartBatch(id: 1, at: now, by: user.id);

    state = Cart(
      id: ObjectId().hexString,
      rc: rc,
      saleMode: saleMode,
      pax: pax,
      outletId: outlet.id,
      sessionId: session.id,
      batches: [initialBatch],
      logs: [initialLog],
      createdAt: now,
      createdBy: user.id,
      updatedAt: now,
      updatedBy: user.id,
    );
  }

  void updateSalesAndPax(SaleMode saleMode, int pax) {
    state = state.copyWith(saleMode: saleMode, pax: pax);
  }

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

  void removeItem(CartItem item) {
    final items = state.items.toList();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    items.removeAt(index);
    state = state.copyWith(items: items);
    _recalculateCart();
  }

  void clearAllItems() {
    state = state.copyWith(
      items: [],
      gross: 0,
      net: 0,
    );
  }

  void reset() {
    state = const Cart();
  }

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

    final outlet = ref.read(outletProvider);
    unawaited(ref.read(printerStateProvider.notifier).print(TemplateReceipt(state, outlet)));

    // Reset after screen success
    // reset();
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
