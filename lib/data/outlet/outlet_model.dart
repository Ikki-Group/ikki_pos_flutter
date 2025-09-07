import 'package:freezed_annotation/freezed_annotation.dart';

import '../json.dart';
import 'outlet_constant.dart';

part 'outlet_model.freezed.dart';
part 'outlet_model.g.dart';

@freezed
abstract class OutletStateModel with _$OutletStateModel {
  const factory OutletStateModel({
    required OutletModel outlet,
    required OutletDeviceModel device,
    OutletSessionModel? session,
  }) = _OutletStateModel;

  factory OutletStateModel.fromJson(Json json) => _$OutletStateModelFromJson(json);
}

@freezed
abstract class OutletModel with _$OutletModel {
  const factory OutletModel({
    required String id,
    required String name,
    required String code,
    required String type,
    required String createdAt,
    required String updatedAt,
    required String createdBy,
    required String updatedBy,
  }) = _OutletModel;

  factory OutletModel.fromJson(Json json) => _$OutletModelFromJson(json);
}

@freezed
abstract class OutletDeviceModel with _$OutletDeviceModel {
  const factory OutletDeviceModel({
    required String id,
    required String name,
    required OutletDeviceType type,
    required String code,
    required String createdAt,
    required String updatedAt,
    required String createdBy,
    required String updatedBy,
  }) = _OutletDeviceModel;

  factory OutletDeviceModel.fromJson(Json json) => _$OutletDeviceModelFromJson(json);
}

@freezed
abstract class OutletSessionModel with _$OutletSessionModel {
  const factory OutletSessionModel({
    required String id,
    @Default(0) int trxCount,
    @Default(0) int trxSuccess,
    @Default(0) int trxFail,
    @Default(0) int netSales,
    @Default(0) int cash,
    @Default(1) int queue,
    @Default(OutletSessionInfo()) OutletSessionInfo open,
    @Default(OutletSessionInfo()) OutletSessionInfo close,
  }) = _OutletSessionModel;

  factory OutletSessionModel.fromJson(Json json) => _$OutletSessionModelFromJson(json);
}

@freezed
abstract class OutletSessionInfo with _$OutletSessionInfo {
  const factory OutletSessionInfo({
    @Default('') String at,
    @Default('') String by,
    @Default(0) int cashBalance,
    String? note,
  }) = _OutletSessionInfo;

  factory OutletSessionInfo.fromJson(Json json) => _$OutletSessionInfoFromJson(json);
}
