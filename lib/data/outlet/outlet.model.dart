import 'package:freezed_annotation/freezed_annotation.dart';

import '../json.dart';

part 'outlet.model.freezed.dart';
part 'outlet.model.g.dart';

@freezed
abstract class OutletModel with _$OutletModel {
  const factory OutletModel({
    required String id,
    required String name,
    required String type,
    required String syncAt,
    required String createdAt,
    required String updatedAt,
    required String createdBy,
    required String updatedBy,
    @Default(OutletSessionModel()) OutletSessionModel session,
  }) = _OutletModel;

  factory OutletModel.fromJson(Json json) => _$OutletModelFromJson(json);
}

@freezed
abstract class OutletSessionModel with _$OutletSessionModel {
  const factory OutletSessionModel({
    @Default('') String id,
    @Default(OutletSessionSummaryModel()) OutletSessionSummaryModel summary,
    @Default(OutletSessionInfo()) OutletSessionInfo open,
    @Default(OutletSessionInfo()) OutletSessionInfo close,
  }) = _OutletSessionModel;

  factory OutletSessionModel.fromJson(Json json) => _$OutletSessionModelFromJson(json);
}

@freezed
abstract class OutletSessionSummaryModel with _$OutletSessionSummaryModel {
  const factory OutletSessionSummaryModel({
    @Default(0) int trxCount,
    @Default(0) int trxSuccess,
    @Default(0) int trxFail,
    @Default(0) int netSales,
    @Default(0) int cash,
  }) = _OutletSessionSummaryModel;

  factory OutletSessionSummaryModel.fromJson(Json json) => _$OutletSessionSummaryModelFromJson(json);
}

@freezed
abstract class OutletSessionInfo with _$OutletSessionInfo {
  const factory OutletSessionInfo({
    @Default('') String at,
    @Default('') String by,
    @Default(0) int balance,
    String? note,
  }) = _OutletSessionInfo;

  factory OutletSessionInfo.fromJson(Json json) => _$OutletSessionInfoFromJson(json);
}
