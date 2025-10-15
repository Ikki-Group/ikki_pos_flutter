import 'package:dio/dio.dart';

import '../core/logger/talker_logger.dart';

/// App exception handle any error that can be handled by the app.
/// - DioException
/// - Exception
class AppException implements Exception {
  AppException({
    required this.msg,
    this.code = 'AppException',
    this.error,
    this.stackTrace,
  });

  factory AppException.fromDio(DioException e) {
    final data = e.response?.data;

    var msg = 'DioException: ${e.type}';
    var code = e.type.toString();

    if (data is Map) {
      if (data['message'] is String) msg = data['message'] as String;
      if (data['code'] is String) code = data['code'] as String;
    }

    logger.error('[AppException.fromDio] message: $msg | code: $code | error: $e');
    return AppException(
      msg: msg,
      code: code,
      error: e.error,
      stackTrace: e.stackTrace,
    );
  }

  factory AppException.fromException(Exception e, StackTrace? stackTrace) => AppException(
    msg: e.toString(),
    code: e.runtimeType.toString(),
    error: e,
    stackTrace: stackTrace,
  );

  factory AppException.fromObject(Object e, StackTrace? stackTrace) {
    if (e is DioException) {
      return AppException.fromDio(e);
    } else if (e is Exception) {
      return AppException.fromException(e, stackTrace);
    }

    return AppException(
      msg: e.toString(),
      code: e.runtimeType.toString(),
      error: e,
      stackTrace: stackTrace,
    );
  }

  final String msg;
  final String code;

  /// The original error/exception object;
  final Object? error;

  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppException{msg: $msg, code: $code, error: $error, stackTrace: $stackTrace}';
  }
}
