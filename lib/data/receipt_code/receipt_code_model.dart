import 'package:freezed_annotation/freezed_annotation.dart';

import '../json.dart';

part 'receipt_code_model.freezed.dart';
part 'receipt_code_model.g.dart';

@freezed
abstract class ReceiptCodeModel with _$ReceiptCodeModel {
  const factory ReceiptCodeModel({
    required String prefix,
  }) = _ReceiptCodeModel;

  factory ReceiptCodeModel.fromJson(Json json) => _$ReceiptCodeModelFromJson(json);
}
