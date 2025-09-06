import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/sembast.dart';
import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../../utils/result.dart';
import 'auth_model.dart';
import 'auth_util.dart';

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
  Future<Result<String>> authenticate(String code);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool?> setToken(String token);
}

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({required this.dio, required this.sp, required this.sembastService});

  final Dio dio;
  final SharedPreferences sp;
  final SembastService sembastService;

  @override
  Future<Result<String>> authenticate(String code) async {
    try {
      final deviceInfo = await getDeviceInfo();
      final _ = AuthRequest(
        code: code,
        deviceInfo: deviceInfo,
      );

      await setToken(_mockAuthResponse.token);
      return const Result.success('Auth Success');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await sp.clear();
    await sembastService.db.dropAll();
  }

  @override
  Future<String?> getToken() async {
    final token = sp.getString(SharedPrefsKeys.authToken.key);
    return token;
  }

  @override
  Future<bool?> setToken(String token) async {
    return sp.setString(SharedPrefsKeys.authToken.key, token);
  }
}

const _mockAuthResponse = AuthResponse(
  token: 'supersecret',
);
