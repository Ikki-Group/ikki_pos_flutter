import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'auth_api_model.dart';

Future<AuthDeviceInfo> getDeviceInfo() async {
  var di = const AuthDeviceInfo();

  if (Platform.isAndroid) {
    final andro = await DeviceInfoPlugin().androidInfo;
    di = di.copyWith(
      os: '${andro.device} ${andro.version} ${andro.brand}',
      model: andro.model,
      appVersion: 'v1.0.0',
      deviceId: andro.serialNumber,
    );
  } else if (Platform.isIOS) {
    final ios = await DeviceInfoPlugin().iosInfo;
    di = di.copyWith(
      os: '${ios.systemName} ${ios.systemVersion} ${ios.model}',
      model: ios.model,
      appVersion: 'v1.0.0',
      deviceId: ios.identifierForVendor ?? '',
    );
  } else {
    di = di.copyWith(
      os: 'Unknown',
      model: 'Unknown',
      appVersion: 'v1.0.0',
      deviceId: 'Unknown',
    );
  }

  return di;
}
