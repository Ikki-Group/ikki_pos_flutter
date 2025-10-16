import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/db/sembast.dart';
import '../../../core/db/shared_prefs.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/exception.dart';
import '../../../utils/result.dart';
import 'auth_dto.dart';

part 'auth_repo.g.dart';

@Riverpod(keepAlive: true)
AuthRepo authRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  final sembastService = ref.watch(sembastServiceProvider);
  return AuthRepoImpl(
    dio: dio,
    sp: sp,
    sembastService: sembastService,
  );
}

abstract class AuthRepo {
  // Token Management
  Future<String?> getToken();
  Future<bool?> setToken(String token);
  Future<bool> logout();

  // Api Call
  Future<Result<String>> authenticate(String code);

  // Device info
  Future<AuthDeviceInfo> getDeviceInfo();
}

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({required this.dio, required this.sp, required this.sembastService});

  final Dio dio;
  final SharedPreferences sp;
  final SembastService sembastService;

  @override
  Future<String?> getToken() async {
    final token = sp.getString(SharedPrefsKeys.authToken.key);
    return token;
  }

  @override
  Future<bool?> setToken(String token) async {
    return sp.setString(SharedPrefsKeys.authToken.key, token);
  }

  @override
  Future<bool> logout() async {
    return sp.remove(SharedPrefsKeys.authToken.key);
  }

  @override
  Future<Result<String>> authenticate(String code) async {
    try {
      final deviceInfo = await getDeviceInfo();
      final res = await dio.post(
        ApiConfig.outletDeviceClaim,
        data: AuthRequest(claimCode: code, meta: deviceInfo).toJson(),
      );

      final token = res.data['data']['token'] as String;
      await setToken(token);
      return const Result.success('Auth Success');
    } catch (e, st) {
      return Result.failure(AppException.fromObject(e, st));
    }
  }

  @override
  Future<AuthDeviceInfo> getDeviceInfo() async {
    var di = const AuthDeviceInfo(
      os: 'Unknown',
      model: 'Unknown',
      appVersion: 'v1.0.0',
      osVersion: 'Unknown',
      deviceId: 'Unknown',
    );

    if (Platform.isAndroid) {
      final andro = await DeviceInfoPlugin().androidInfo;
      di = di.copyWith(
        os: '${andro.device} ${andro.version} ${andro.brand}',
        osVersion: andro.version.release,
        model: andro.model,
        deviceId: andro.id,
      );
    } else if (Platform.isIOS) {
      final ios = await DeviceInfoPlugin().iosInfo;
      di = di.copyWith(
        os: '${ios.systemName} ${ios.systemVersion} ${ios.model}',
        model: ios.model,
        deviceId: ios.identifierForVendor ?? '',
        osVersion: ios.systemVersion,
      );
    }

    return di;
  }
}
