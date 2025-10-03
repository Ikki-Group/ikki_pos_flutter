import '../../../core/config/app_constant.dart';
import '../../../shared/utils/formatter.dart';
import '../model/cart_state.dart';

extension CartStateX on CartState {
  int get itemsCount => items.fold<int>(0, (prev, curr) => prev + curr.qty);

  List<CartItem> get currentItems => items.where((item) => item.batchId == batchId).toList();

  CartState recalculate() {
    final gross = currentItems.fold<double>(0, (prev, curr) => prev + curr.gross);
    final discount = currentItems.fold<double>(0, (prev, curr) => prev + curr.discount);
    final net = gross - discount;
    return copyWith(gross: gross, discount: discount, net: net);
  }
}

extension CartPaymentX on CartPayment {
  String get formattedLabel {
    final idr = Formatter.toIdr.format(amount);
    if (type == PaymentType.cash) return 'Tunai: $idr';
    return '$label: $idr';
  }
}
