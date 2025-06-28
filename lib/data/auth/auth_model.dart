import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class AuthDeviceReq with _$AuthDeviceReq {
  const factory AuthDeviceReq({
    required String key,
    required DeviceInfoDto deviceInfo,
  }) = _AuthDeviceReq;

  factory AuthDeviceReq.fromJson(Map<String, dynamic> json) => _$AuthDeviceReqFromJson(json);
}

@freezed
abstract class AuthDeviceRes with _$AuthDeviceRes {
  const factory AuthDeviceRes({
    required String id,
    required String token,
    required String outletId,
    required String deviceName,
    required ReceiptDto receipt,
  }) = _AuthDeviceRes;

  factory AuthDeviceRes.fromJson(Map<String, dynamic> json) => _$AuthDeviceResFromJson(json);
}

@freezed
abstract class DeviceInfoDto with _$DeviceInfoDto {
  const factory DeviceInfoDto({
    required String os,
    required String model,
    required String appVersion,
    required String deviceId,
  }) = _DeviceInfoDto;

  factory DeviceInfoDto.fromJson(Map<String, dynamic> json) => _$DeviceInfoDtoFromJson(json);

  static Future<DeviceInfoDto> current() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    var deviceInfo = DeviceInfoDto(
      os: "Unknown OS",
      model: 'Unknown Model',
      appVersion: Platform.version,
      deviceId: 'fallback_device_id_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await info.androidInfo;
      deviceInfo = DeviceInfoDto(
        os: 'Android ${androidInfo.version.release}',
        model: androidInfo.model,
        appVersion: androidInfo.version.sdkInt.toString(),
        deviceId: androidInfo.id,
      );
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await info.iosInfo;
      deviceInfo = deviceInfo.copyWith(
        os: 'iOS ${iosInfo.systemVersion}',
        model: iosInfo.model,
        appVersion: iosInfo.systemVersion,
        deviceId: iosInfo.identifierForVendor ?? 'fallback_device_id_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    return deviceInfo;
  }
}

@freezed
abstract class ReceiptDto with _$ReceiptDto {
  const factory ReceiptDto({required String prefix, required int counter}) = _ReceiptDto;

  factory ReceiptDto.fromJson(Map<String, dynamic> json) => _$ReceiptDtoFromJson(json);
}
