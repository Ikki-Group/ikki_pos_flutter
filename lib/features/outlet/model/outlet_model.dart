import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import 'shift_status.dart';

part 'outlet_model.freezed.dart';
part 'outlet_model.g.dart';

@freezed
abstract class OutletModel with _$OutletModel {
  const factory OutletModel({
    required String id,
    required String name,
    required String code,
    String? desc,
    String? email,
    String? phone,
    String? address,
    required String type,
    required String createdAt,
    required String createdBy,
    required String updatedAt,
    required String updatedBy,
  }) = _OutletModel;

  factory OutletModel.fromJson(Json json) => _$OutletModelFromJson(json);

  factory OutletModel.empty() => OutletModel(
    id: '',
    name: '',
    code: '',
    desc: '',
    email: '',
    phone: '',
    address: '',
    type: '',
    createdAt: '',
    createdBy: '',
    updatedAt: '',
    updatedBy: '',
  );
}

@freezed
abstract class OutletSessionModel with _$OutletSessionModel {
  const factory OutletSessionModel({
    required String id,
    required String outletId,
    required ShiftStatus status,
    @Default(0) int trxCount,
    @Default(0) int trxSuccess,
    @Default(0) int trxFail,
    @Default(0) double netSales,
    @Default(0) double cash,
    @Default(1) int queue,
    @Default(OutletSessionInfo()) OutletSessionInfo open,
    @Default(OutletSessionInfo()) OutletSessionInfo close,
  }) = _OutletSessionModel;

  factory OutletSessionModel.fromJson(Json json) => _$OutletSessionModelFromJson(json);

  factory OutletSessionModel.empty() => OutletSessionModel(
    id: '',
    outletId: '',
    open: OutletSessionInfo.empty(),
    close: OutletSessionInfo.empty(),
    status: ShiftStatus.close,
  );
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

  factory OutletSessionInfo.empty() => OutletSessionInfo(
    at: '',
    by: '',
    balance: 0,
    note: '',
  );
}
