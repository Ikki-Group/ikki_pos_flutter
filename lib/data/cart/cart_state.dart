import 'dart:convert';
import 'dart:developer' as dev;

import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../outlet/outlet.provider.dart';
import '../product/product.model.dart';
import '../receipt_code/receipt_code_repo.dart';
import '../sale/sale_enum.dart';
import '../user/user.model.dart';
import '../user/user.provider.dart';
import 'cart_extension.dart';
import 'cart_model.dart';
import 'cart_repo.dart';

part 'cart_state.g.dart';

enum CartLogAction {
  create;

  @override
  String toString() {
    return name.split('.').last.toUpperCase();
  }
}

@Riverpod(keepAlive: true)
class CartState extends _$CartState {
  @override
  Cart build() => const Cart();

  // ignore: use_setters_to_change_properties
  void setCart(Cart cart) => state = cart;

  void setState(Cart Function(Cart) fn) => state = fn(state);

  Future<void> newCart(
    int pax,
    SaleMode saleMode,
  ) async {
    final outlet = await ref.read(outletProvider.future).then((value) => value.requireOpen);
    final sessionId = outlet.session.id;
    final rc = await ref.read(receiptCodeRepoProvider).getCode(sessionId);
    final user = _getUser();

    final initialLog = _buildLog(action: CartLogAction.create, message: 'Cart created');
    final initialBatch = CartBatch(id: 1, at: DateTime.now().toString(), by: user.id);

    state = Cart(
      id: ObjectId().hexString,
      rc: rc,
      saleMode: saleMode,
      pax: pax,
      outletId: outlet.id,
      sessionId: sessionId,
      batches: [initialBatch],
      logs: [initialLog],
      createdAt: DateTime.now().toIso8601String(),
      createdBy: user.id,
      updatedAt: DateTime.now().toIso8601String(),
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

  Future<void> save() async {
    state = state.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      updatedBy: ref.read(currentUserProvider.notifier).requireUser().id,
    );

    await ref.read(cartRepoProvider).save(state);
    await ref.read(receiptCodeRepoProvider).commit(state.rc);
    reset();
  }

  // Internal methods

  UserModel _getUser() {
    return ref.read(currentUserProvider.notifier).requireUser();
  }

  String _buildLog({
    required CartLogAction action,
    String? message,
  }) {
    final user = ref.read(currentUserProvider.notifier).requireUser();
    final msg =
        '[${DateTime.now().toIso8601String()}]-[$action]-[${user.id}-${user.name}]-[${jsonEncode(state.toString())}] $message';
    dev.log(msg);
    return msg;
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
