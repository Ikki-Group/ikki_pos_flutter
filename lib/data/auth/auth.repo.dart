import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/config/app_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'auth.model.dart';

part 'auth.repo.g.dart';

@riverpod
AuthRepo authRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepo(dio: dio);
}

class AuthRepo {
  AuthRepo({required this.dio});

  final Dio dio;

  Future<AuthResponse> authenticate(
    AuthRequest req,
  ) async {
    final res = await dio.post<Json>(
      ApiEndpoints.deviceVerifyToken,
      data: req.toJson(),
    );

    return AuthResponse.fromJson(res.data!);
  }

  Future<AuthResponse> authenticateMock(
    AuthRequest req,
  ) async {
    return const AuthResponse(
      id: 'id',
      token: 'token',
      outletId: 'outletId',
      deviceName: 'deviceName',
      receipt: AuthReceiptConfig(
        prefix: 'prefix',
        counter: 1,
      ),
    );
  }

  Future<AuthDeviceInfo> getDeviceInfo() async {
    return const AuthDeviceInfo(
      os: 'os',
      model: 'model',
      appVersion: 'appVersion',
      deviceId: 'deviceId',
    );
  }
}
