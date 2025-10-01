import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
abstract class AuthRequest with _$AuthRequest {
  const factory AuthRequest({
    required String claimCode,
    required AuthDeviceInfo meta,
  }) = _AuthRequest;

  factory AuthRequest.fromJson(Json json) => _$AuthRequestFromJson(json);
}

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Json json) => _$AuthResponseFromJson(json);
}

@freezed
abstract class AuthDeviceInfo with _$AuthDeviceInfo {
  const factory AuthDeviceInfo({
    @Default('') String os,
    @Default('') String model,
    @Default('') String appVersion,
    @Default('') String osVersion,
    @Default('') String deviceId,
  }) = _AuthDeviceInfo;

  factory AuthDeviceInfo.fromJson(Json json) => _$AuthDeviceInfoFromJson(json);
}
