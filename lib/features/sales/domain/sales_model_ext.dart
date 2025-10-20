import '../../../core/config/app_constant.dart';
import '../../../utils/formatter.dart';
import 'sales_model.dart';

extension SalesPaymentX on SalesPayment {
  bool get isCash => type == PaymentType.cash;

  String get formattedLabel {
    final idr = Formatter.toIdr.format(amount);
    if (isCash) return 'Tunai: $idr';
    return '$label: $idr';
  }
}
