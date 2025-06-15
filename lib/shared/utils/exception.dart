import 'package:dio/dio.dart';

/// App exception handle any error that can be handled by the app.
/// - DioException
/// - Exception
class AppException implements Exception {
  final String msg;
  final String code;

  /// The original error/exception object;
  final Object? error;

  final StackTrace? stackTrace;

  AppException({
    required this.msg,
    this.code = 'AppException',
    this.error,
    this.stackTrace,
  });

  factory AppException.fromDio(DioException e) {
    final data = e.response?.data;
    var msg = "DioException: ${e.type.toString()}";
    if (data is Map) {
      print(data);
      if (data['msg'] != null) {
        msg = data['msg'];
      }
    }

    return AppException(
      msg: msg,
      code: e.type.toString(),
      error: e.error,
      stackTrace: e.stackTrace,
    );
  }

  factory AppException.fromException(Exception e, StackTrace? stackTrace) =>
      AppException(
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

  @override
  String toString() {
    return 'AppException{msg: $msg, code: $code, error: $error, stackTrace: $stackTrace}';
  }
}
