import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import '../../common/model/sync_meta_model.dart';
import 'shift_status.dart';

part 'shift_session_model.freezed.dart';
part 'shift_session_model.g.dart';

@freezed
abstract class ShiftSessionModel with _$ShiftSessionModel {
  const factory ShiftSessionModel({
    required String id,
    required String outletId,
    required String day,
    required String code,
    required ShiftStatus status,
    required ShiftSessionInfo open,
    required ShiftSessionInfo close,
    required SessionSummary summary,
    required String createdAt,
    required String createdBy,
    required String updatedAt,
    required String updatedBy,
    required SyncMetaModel syncMeta,
  }) = _ShiftSessionModel;

  factory ShiftSessionModel.fromJson(Json json) => _$ShiftSessionModelFromJson(json);
}

@freezed
abstract class ShiftSessionInfo with _$ShiftSessionInfo {
  const factory ShiftSessionInfo({
    required String by,
    required String at,
    required int balance,
    String? note,
  }) = _ShiftSessionInfo;

  factory ShiftSessionInfo.empty() => ShiftSessionInfo(
    by: '',
    at: '',
    balance: 0,
    note: '',
  );

  factory ShiftSessionInfo.fromJson(Json json) => _$ShiftSessionInfoFromJson(json);
}

@freezed
abstract class SessionSummary with _$SessionSummary {
  const factory SessionSummary({
    @Default(0) int expectedCash,
    @Default(0) int actualCash,
    @Default(0) int cashVariance,
    @Default(0) int totalOrders,
    @Default(0) int totalVoids,
    @Default(0) int totalSales,
    @Default(0) int cashSales,
    @Default(0) int nonCashSales,
    @Default(0) int refunds,
  }) = _SessionSummary;

  factory SessionSummary.fromJson(Json json) => _$SessionSummaryFromJson(json);
}
