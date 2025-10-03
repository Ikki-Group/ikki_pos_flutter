import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import 'printer_enum.dart';

part 'printer_model.freezed.dart';
part 'printer_model.g.dart';

@freezed
sealed class PrinterModel with _$PrinterModel {
  const factory PrinterModel({
    required String id,
    required String name,
    required PrinterConnectionType connectionType,
    String? host,
    int? port,
    String? address,
    @Default(false) bool isConnected,
  }) = _PrinterModel;

  factory PrinterModel.fromJson(Json json) => _$PrinterModelFromJson(json);
}
