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
    final items = List<CartItem>.from(state.items); // Create mutable copy

    final targetIdx = items.indexWhere(
      (item) => item.product.id == product.id && item.note.isEmpty,
    );

    if (targetIdx != -1) {
      // Update existing item
      final item = items[targetIdx];
      final updatedItem = item.changeQty(1);

      // Replace item in list
      items[targetIdx] = updatedItem;

      // Update state with recalculated totals
      state = state.copyWith(items: items);
      _recalculateCart();
    } else {
      // Add new item to cart
      final newItem = CartItem(
        id: ObjectId().toString(),
        batch: state.batchId, // Use current batch from state
        product: CartItemProduct(
          id: product.id,
          name: product.name,
          price: product.price,
        ),
        qty: 1,
        price: product.price,
        gross: product.price * 1, // qty = 1
        net: product.price * 1, // no discount initially
      );

      items.add(newItem);

      // Update state and recalculate
      state = state.copyWith(items: items);
      _recalculateCart();
    }
  }

  // void addProductDirectly(ProductModel product) {
  //   final items = state.items;

  //   final targetIdx = items.indexWhere(
  //     (item) => item.product.id == product.id && item.note.isEmpty,
  //   );

  //   if (targetIdx != -1) {
  //     final item = items[targetIdx];
  //     final updatedItem = item.changeQty(1);

  //     state = state.copyWith(
  //       items: [
  //         ...items.sublist(0, targetIdx),
  //         updatedItem,
  //         ...items.sublist(targetIdx + 1),
  //       ],
  //       gross: state.gross,
  //       net: state.net,
  //     );
  //   } else {
  //     // Add new item to cart
  //     final newItem = CartItem(
  //       id: ObjectId().toString(),
  //       batch: 1,
  //       product: CartItemProduct(
  //         id: product.id,
  //         name: product.name,
  //         price: product.price,
  //       ),
  //       qty: 1,
  //       price: product.price,
  //       gross: product.price,
  //       net: product.price,
  //     );

  //     state = state.copyWith(
  //       items: [...items, newItem],
  //       gross: state.gross + (product.price),
  //       net: state.net + (product.price),
  //     );
  //   }
  // }

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
