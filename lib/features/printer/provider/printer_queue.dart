import 'package:queue/queue.dart';

import '../../../core/logger/talker_logger.dart';

class PrinterQueue {
  factory PrinterQueue() {
    return _instance;
  }

  PrinterQueue._internal();
  static final PrinterQueue _instance = PrinterQueue._internal();

  final queue = Queue();

  void init() {
    logger.info('[PrinterQueue] init');
  }
}
