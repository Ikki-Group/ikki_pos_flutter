import 'cart.model.dart';

extension CartItemX on CartItem {
  CartItem changeQty(int actionQty) {
    final newQty = qty + actionQty;
    final gross = newQty * product.price;
    final net = gross;
    return copyWith(qty: qty, gross: gross, net: net);
  }
}
