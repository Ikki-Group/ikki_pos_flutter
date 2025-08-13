import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_api_model.freezed.dart';
part 'auth_api_model.g.dart';

@freezed
abstract class AuthRequest with _$AuthRequest {
  const factory AuthRequest({
    required String key,
    required AuthDeviceInfo deviceInfo,
  }) = _AuthRequest;

  factory AuthRequest.fromJson(Map<String, dynamic> json) => _$AuthRequestFromJson(json);
}

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String id,
    required String token,
    required String outletId,
    required String deviceName,
    required AuthReceiptConfig receipt,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}

@freezed
abstract class AuthDeviceInfo with _$AuthDeviceInfo {
  const factory AuthDeviceInfo({
    @Default('') String os,
    @Default('') String model,
    @Default('') String appVersion,
    @Default('') String deviceId,
  }) = _AuthDeviceInfo;

  factory AuthDeviceInfo.fromJson(Map<String, dynamic> json) => _$AuthDeviceInfoFromJson(json);
}

@freezed
abstract class AuthReceiptConfig with _$AuthReceiptConfig {
  const factory AuthReceiptConfig({
    required String prefix,
    required int counter,
  }) = _AuthReceiptConfig;

  factory AuthReceiptConfig.fromJson(Map<String, dynamic> json) => _$AuthReceiptConfigFromJson(json);
}
