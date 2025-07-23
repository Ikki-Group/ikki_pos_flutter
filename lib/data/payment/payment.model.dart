import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment.enum.dart';

part 'payment.model.freezed.dart';
part 'payment.model.g.dart';

@freezed
sealed class PaymentOption with _$PaymentOption {
  const factory PaymentOption({
    required String id,
    required String name,
    required PaymentMode mode,
  }) = _PaymentOption;

  factory PaymentOption.fromJson(Map<String, dynamic> json) => _$PaymentOptionFromJson(json);
}
