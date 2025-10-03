import '../../../core/config/app_constant.dart';
import '../../../shared/utils/formatter.dart';
import 'cart_state.dart';

extension CartStateX on CartState {
  int get itemsCount => items.fold<int>(0, (prev, curr) => prev + curr.qty);

  List<CartItem> get currentItems => items.where((item) => item.batchId == batchId).toList();

  CartState recalculate() {
    final gross = currentItems.fold<double>(0, (prev, curr) => prev + curr.gross);
    final discount = currentItems.fold<double>(0, (prev, curr) => prev + curr.discount);
    final net = gross - discount;
    return copyWith(gross: gross, discount: discount, net: net);
  }

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

extension CartPaymentX on CartPayment {
  String get formattedLabel {
    final idr = Formatter.toIdr.format(amount);
    if (type == PaymentType.cash) return 'Tunai: $idr';
    return '$label: $idr';
  }
}
