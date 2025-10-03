import 'package:intl/intl.dart';

import 'outlet_model.dart';
import 'outlet_state.dart';
import 'shift_status.dart';

extension XOutletState on OutletState {
  bool get isOpen => session?.status == ShiftStatus.open;

  OutletSessionModel get sessionRequired {
    if (session == null) throw Exception('Outlet session is null');
    return session!;
  }

  OutletSessionModel? get whenOpenOrNull => isOpen ? sessionRequired : null;

  String get receiptCode {
    final session = sessionRequired;
    final deviceCode = device.code;
    // Pick 4 digits
    final sessionCode = session.id.substring(session.id.length - 2);
    final queue = session.queue.toString().padLeft(2, '0');
    final date = DateFormat('yyyyMMdd').format(DateTime.now());

    return '$deviceCode/$date/$sessionCode/$queue';
  }
}
