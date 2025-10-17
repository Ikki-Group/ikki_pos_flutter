import 'cart_state.dart';

extension CartStateX on CartState {
  bool get isEmptyState => id.isEmpty;

  int get itemsCount => items.fold<int>(0, (prev, curr) => prev + curr.qty);

  List<CartItem> get currentItems => items.where((item) => item.batchId == batchId).toList();

  double get gross => items.fold<double>(0, (prev, curr) => prev + curr.gross);
  double get discount => items.fold<double>(0, (prev, curr) => prev + curr.discount);
  double get net => gross - discount;
}

extension CartItemX on CartItem {
  double get price => variant?.price ?? product.price;
  double get gross => qty * price;
  // TODO
  double get discount => 0;
  double get net => gross - discount;
}
