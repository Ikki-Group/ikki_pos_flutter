import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import 'auth_api_model.dart';

part 'auth_repo.g.dart';

@riverpod
AuthRepo authRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepo(dio: dio);
}

class AuthRepo {
  AuthRepo({required this.dio});
  final Dio dio;

  Future<AuthResponse> authenticate(AuthRequest req) async {
    return _mockAuthResponse;
  }
}

const _mockAuthResponse = AuthResponse(
  id: 'id',
  token: 'token',
  outletId: 'outletId',
  deviceName: 'deviceName',
  receipt: AuthReceiptConfig(
    prefix: 'prefix',
    counter: 1,
  ),
);
