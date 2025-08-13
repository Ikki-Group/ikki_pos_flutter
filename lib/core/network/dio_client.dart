import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/auth/auth_token_provider.dart';
import '../config/app_config.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 5),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Platform': 'Flutter',
        'X-Platform-Version': '1.0.0',
        'X-Developer': 'Rizqy Nugroho',
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
        final token = await ref.read(authTokenProvider.future);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ),
  );

  // Logging interceptor
  // dio.interceptors.add(TalkerDioLogger());

  return dio;
}
