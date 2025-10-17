import '../../../../core/config/app_constant.dart';
import '../model/sales_model.dart';

extension SalesPaymentX on SalesPayment {
  bool get isCash => type == PaymentType.cash;
}
