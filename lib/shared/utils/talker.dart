import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

final logger = TalkerLogger(
  settings: TalkerLoggerSettings(
    level: LogLevel.debug,
    maxLineWidth: 30,
  ),
  formatter: const _MyFormatter(),
);

final talker = Talker(logger: logger);

TalkerDioLogger initTalkerDioLogger() {
  return TalkerDioLogger(talker: talker);
}

TalkerRouteObserver initTalkerRouteObserver() {
  return TalkerRouteObserver(talker);
}

class _MyFormatter implements LoggerFormatter {
  const _MyFormatter();

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final msg = details.message?.toString() ?? '';
    return '\n$msg\n';
  }
}

/// Useful to log state change in our application
/// Read the logs and you'll better understand what's going on under the hood
class TalkerStateLogger extends ProviderObserver {
  const TalkerStateLogger();

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    logger.debug('''
{
  provider: ${context.provider.name},
  prev: $previousValue,
  new: $newValue
}
''');
  }
}
