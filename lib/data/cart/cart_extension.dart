import '../product/product.model.dart';
import 'cart_model.dart';

extension CartItemX on CartItem {
  CartItem changeQty(int actionQty) {
    final newQty = qty + actionQty;
    final gross = newQty * price;
    final net = gross;
    return copyWith(qty: newQty, gross: gross, net: net);
  }
}

extension CartX on Cart {
  bool get isItemInBatchEmpty => items.indexWhere((item) => item.batchId == batchId).isNegative;
  bool get isItemEmpty => items.isEmpty;

  String get label {
    var name = '-';

    if (customer != null && customer!.name.isNotEmpty) {
      name = customer!.name;
    } else if (note.isNotEmpty) {
      name = note;
    }
    return name;
  }
}

extension ProductModelX on ProductModel {
  CartItemProduct toCartItemProduct() {
    return CartItemProduct(id: id, name: name, price: price);
  }
}
