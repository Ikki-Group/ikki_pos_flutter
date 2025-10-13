import 'package:queue/queue.dart';

import '../../../utils/talker.dart';

class PrinterQueue {
  factory PrinterQueue() {
    return _instance;
  }

  PrinterQueue._internal();
  static final PrinterQueue _instance = PrinterQueue._internal();

  final queue = Queue();

  void init() {
    talker.info('[PrinterQueue] init');
  }
}
