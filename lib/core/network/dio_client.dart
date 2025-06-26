import 'package:dio/dio.dart';
import 'package:ikki_pos_flutter/core/config/app_config.dart';
import 'package:ikki_pos_flutter/shared/providers/app_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 5),
    sendTimeout: const Duration(seconds: 30),
    responseType: ResponseType.json,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Platform': 'Flutter',
      'X-Platform-Version': '1.0.0',
    },
    validateStatus: (status) {
      // Only 2xx
      if (status == null) return false;
      return status >= 200 && status < 300;
    },
  );

  // Auth interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(appTokenProvider.future);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle token expiry
        if (error.response?.statusCode == 401) {
          // ref.read(authTokenProvider.notifier).clearToken();
          // Optionally redirect to login
        }
        handler.next(error);
      },
    ),
  );

  // Logging interceptor
  // dio.interceptors.add(TalkerDioLogger());

  return dio;
}
