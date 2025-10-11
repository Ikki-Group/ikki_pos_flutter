import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../../features/auth/provider/auth_token_provider.dart';
import '../../shared/utils/talker.dart';
import '../config/app_config.dart';
import '../config/app_constant.dart';

part 'dio_client.g.dart';

final dioOptions = BaseOptions(
  baseUrl: ApiConfig.baseUrl,
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(minutes: 5),
  sendTimeout: Duration(seconds: 30),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Platform': AppConstants.appName,
    'X-Platform-Version': AppConstants.appVersion,
    'X-Developer': 'Rizqy Nugroho',
  },
  validateStatus: (status) {
    // Only 2xx
    if (status == null) return false;
    return status >= 200 && status < 300;
  },
);

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final dio = Dio();
  dio.options = dioOptions;

  // Auth interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = ref.read(authTokenProvider);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        talker.debug("Token: $token");
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ),
  );

  // Logging interceptor
  dio.interceptors.add(
    TalkerDioLogger(
      settings: TalkerDioLoggerSettings(
        enabled: false,
        printErrorHeaders: false,
      ),
    ),
  );

  return dio;
}
