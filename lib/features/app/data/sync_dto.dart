import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/device_model.dart';
import '../../../model/outlet_model.dart';
import '../../../model/user_model.dart';
import '../../../utils/json.dart';

part 'sync_dto.freezed.dart';
part 'sync_dto.g.dart';

@freezed
abstract class OutletDeviceSyncResponseDto with _$OutletDeviceSyncResponseDto {
  const factory OutletDeviceSyncResponseDto({
    required DeviceModel device,
    required OutletModel outlet,
    required List<UserModel> users,
  }) = _OutletDeviceSyncResponseDto;

  factory OutletDeviceSyncResponseDto.fromJson(Json json) => _$OutletDeviceSyncResponseDtoFromJson(json);
}
