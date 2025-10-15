import '../core/logger/talker_logger.dart';
import 'exception.dart';
import 'result.dart';

abstract class AsyncWrapper {
  static Future<Result<T>> run<T>(
    Future<T> Function() action, {
    String name = "AsyncWrapper",
  }) async {
    try {
      final data = await action();
      return Result.success(data);
    } catch (e, s) {
      logger.error('''
name: $name
action: $action
exception: $e
stackTrace: $s
''');
      final appException = AppException.fromObject(e, s);
      return Result.failure(appException);
    }
  }
}
