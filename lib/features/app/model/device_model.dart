import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import 'device_type.dart';

part 'device_model.freezed.dart';
part 'device_model.g.dart';

@freezed
abstract class DeviceModel with _$DeviceModel {
  const factory DeviceModel({
    required String id,
    required String outletId,
    required String name,
    required String code,
    required String desc,
    required DeviceType type,
    required String status,
    required String claimCode,
    required String claimedAt,
    required String lastSyncAt,
    Json? meta,
    required String createdAt,
    required String createdBy,
    required String updatedAt,
    required String updatedBy,
  }) = _DeviceModel;

  factory DeviceModel.fromJson(Json json) => _$DeviceModelFromJson(json);

  factory DeviceModel.empty() => DeviceModel(
    id: '',
    outletId: '',
    name: '',
    code: '',
    desc: '',
    type: DeviceType.cashier,
    status: '',
    claimCode: '',
    claimedAt: '',
    lastSyncAt: '',
    meta: null,
    createdAt: '',
    createdBy: '',
    updatedAt: '',
    updatedBy: '',
  );
}
