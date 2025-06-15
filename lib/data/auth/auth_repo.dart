import 'package:fpdart/fpdart.dart';
import 'package:ikki_pos_flutter/core/config/app_endpoints.dart';
import 'package:ikki_pos_flutter/core/network/api_client.dart';
import 'package:ikki_pos_flutter/data/auth/auth_model.dart';
import 'package:ikki_pos_flutter/shared/utils/exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repo.g.dart';

@riverpod
AuthRepo authRepo(ref) {
  final api = ref.watch(apiClientProvider);
  return AuthRepo(api: api);
}

class AuthRepo {
  ApiClient api;

  AuthRepo({required this.api});

  Future<Either<AppException, AuthDeviceRes>> authenticate(
    AuthDeviceReq req,
  ) async {
    try {
      final res = await api.dio.post(
        ApiEndpoints.deviceVerifyToken,
        data: req.toJson(),
      );

      return Right(api.tryParse(res.data, AuthDeviceRes.fromJson));
    } catch (e, st) {
      return Left(AppException.fromObject(e, st));
    }
  }
}
