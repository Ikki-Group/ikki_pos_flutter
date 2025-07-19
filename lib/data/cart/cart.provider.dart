import 'package:bson/bson.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../outlet/outlet.provider.dart';
import '../product/product.model.dart';
import '../receipt_code/receipt_code_repo.dart';
import '../sale/sale.model.dart';
import 'cart.extension.dart';
import 'cart.model.dart';

part 'cart.provider.g.dart';

@Riverpod(keepAlive: true)
class CartState extends _$CartState {
  @override
  Cart build() {
    ref.keepAlive();
    return const Cart();
  }

  // ignore: use_setters_to_change_properties
  void setCart(Cart cart) => state = cart;

  void setState(Cart Function(Cart) fn) => state = fn(state);

  Future<void> newCart(
    int pax,
    SaleMode saleMode,
  ) async {
    final outlet = await ref.read(outletProvider.future);
    final rc = await ref.read(receiptCodeRepoProvider).getCode(outlet.session.id);

    state = Cart(
      id: ObjectId().toString(),
      rc: rc,
      saleMode: saleMode,
      pax: pax,
    );
  }

  void addProductDirectly(ProductModel product) {
    final items = state.items;

    final existingItemIndex = items.indexWhere(
      (item) => item.product.id == product.id && item.note.isEmpty,
    );

    if (existingItemIndex != -1 && items[existingItemIndex].note.isEmpty) {
      final item = items[existingItemIndex];
      final updatedItem = item.changeQty(1);

      state = state.copyWith(
        items: [
          ...items.sublist(0, existingItemIndex),
          updatedItem,
          ...items.sublist(existingItemIndex + 1),
        ],
        gross: state.gross,
        net: state.net,
      );
    } else {
      // Add new item to cart
      final newItem = CartItem(
        id: ObjectId().toString(),
        batch: 1,
        product: CartItemProduct(
          id: product.id,
          name: product.name,
          price: product.price,
        ),
        qty: 1,
        price: product.price,
        gross: product.price,
        net: product.price,
      );

      state = state.copyWith(
        items: [...items, newItem],
        gross: state.gross + (product.price),
        net: state.net + (product.price),
      );
    }
  }

  void removeItem(CartItem item) {
    final items = state.items;
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      state = state.copyWith(
        items: [
          ...items.sublist(0, index),
          ...items.sublist(index + 1),
        ],
        gross: state.gross - (item.gross),
        net: state.net - (item.net),
      );
    }
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
}
