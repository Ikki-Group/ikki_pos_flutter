import 'package:freezed_annotation/freezed_annotation.dart';

import '../json.dart';
import 'printer_enum.dart';

part 'printer_model.freezed.dart';
part 'printer_model.g.dart';

@freezed
sealed class PrinterModel with _$PrinterModel {
  const factory PrinterModel({
    required String id,
    required String name,
    required PrinterConnectionType connectionType,
    PrinterLanInfo? lanInfo,
    PrinterBluetoothInfo? bluetoothInfo,
  }) = _PrinterModel;

  factory PrinterModel.fromJson(Json json) => _$PrinterModelFromJson(json);
}

@freezed
sealed class PrinterLanInfo with _$PrinterLanInfo {
  const factory PrinterLanInfo({
    required String ip,
    required int port,
  }) = _PrinterLanInfo;

  factory PrinterLanInfo.fromJson(Json json) => _$PrinterLanInfoFromJson(json);
}

@freezed
sealed class PrinterBluetoothInfo with _$PrinterBluetoothInfo {
  const factory PrinterBluetoothInfo({
    required String mac,
  }) = _PrinterBluetoothInfo;

  factory PrinterBluetoothInfo.fromJson(Json json) => _$PrinterBluetoothInfoFromJson(json);
}
