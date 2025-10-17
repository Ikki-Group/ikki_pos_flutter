import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../utils/json.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
sealed class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String label,
    required PaymentType type,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Json json) => _$PaymentModelFromJson(json);

  static PaymentModel cash = const PaymentModel(label: 'Cash', type: PaymentType.cash);

  static List<PaymentModel> data = [
    cash,
    const PaymentModel(label: 'Mandiri', type: PaymentType.cashless),
    const PaymentModel(label: 'QRIS', type: PaymentType.cashless),
  ];
}
