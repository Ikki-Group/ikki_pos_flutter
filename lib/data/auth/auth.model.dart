import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.model.freezed.dart';
part 'auth.model.g.dart';

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
    required String os,
    required String model,
    required String appVersion,
    required String deviceId,
  }) = _AuthDeviceInfo;

  factory AuthDeviceInfo.fromJson(Map<String, dynamic> json) => _$AuthDeviceInfoFromJson(json);

  // static Future<DeviceInfo> current() async {
  //   final info = DeviceInfoPlugin();
  //   var deviceInfo = DeviceInfo(
  //     os: 'Unknown OS',
  //     model: 'Unknown Model',
  //     appVersion: Platform.version,
  //     deviceId: 'fallback_device_id_${DateTime.now().millisecondsSinceEpoch}',
  //   );

  //   if (Platform.isAndroid) {
  //     final androidInfo = await info.androidInfo;
  //     deviceInfo = DeviceInfo(
  //       os: 'Android ${androidInfo.version.release}',
  //       model: androidInfo.model,
  //       appVersion: androidInfo.version.sdkInt.toString(),
  //       deviceId: androidInfo.id,
  //     );
  //   } else if (Platform.isIOS) {
  //     final iosInfo = await info.iosInfo;
  //     deviceInfo = deviceInfo.copyWith(
  //       os: 'iOS ${iosInfo.systemVersion}',
  //       model: iosInfo.model,
  //       appVersion: iosInfo.systemVersion,
  //       deviceId: iosInfo.identifierForVendor ?? 'fallback_device_id_${DateTime.now().millisecondsSinceEpoch}',
  //     );
  //   }

  //   return deviceInfo;
  // }
}

@freezed
abstract class AuthReceiptConfig with _$AuthReceiptConfig {
  const factory AuthReceiptConfig({
    required String prefix,
    required int counter,
  }) = _AuthReceiptConfig;

  factory AuthReceiptConfig.fromJson(Map<String, dynamic> json) => _$AuthReceiptConfigFromJson(json);
}
