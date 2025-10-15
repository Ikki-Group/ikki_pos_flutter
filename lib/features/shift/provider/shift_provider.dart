import 'dart:async';

import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/talker_logger.dart';
import '../../../utils/exception.dart';
import '../../outlet/provider/outlet_provider.dart';
import '../data/shift_repo.dart';
import '../model/shift_session_model.dart';
import '../model/shift_status.dart';

part 'shift_provider.g.dart';

@Riverpod(keepAlive: true)
class Shift extends _$Shift {
  @override
  ShiftSessionModel? build() {
    unawaited(loadLocal());
    return null;
  }

  ShiftRepo get _repo => ref.read(shiftRepoProvider);

  Future<void> loadLocal() async {
    logger.info('[ShiftProvider.loadLocal] start');
    state = await _repo.getLocalState();
  }

  Future<void> syncLocal(
    ShiftSessionModel? session,
  ) async {
    logger.info('[ShiftProvider.syncLocal] start');
    await _repo.syncLocalState(session);
    state = session;
    logger.info('[ShiftProvider.syncLocal] end');
  }

  String generateReceiptCode() {
    final dc = ref.read(outletProvider).device.code;
    final session = state.requiredOpen;
    final yyyyMMdd = DateFormat("yyyyMMdd").format(DateTime.now());
    final rc = "$dc/${session.code}/$yyyyMMdd/${001}";
    return rc;
  }

  // TODO
  Future<bool> open(
    String outletId,
    ShiftSessionInfo open,
  ) async {
    logger.info('[ShiftProvider.open] start');
    await _repo.open(outletId, open);
    state = await _repo.getLocalState();
    logger.info('[ShiftProvider.open] end');
    return true;
  }

  Future<void> close(
    String outletId,
    ShiftSessionInfo closeInfo,
  ) async {
    logger.info('[ShiftProvider.close] start');
    await _repo.close(outletId, closeInfo);
    state = await _repo.getLocalState();
    logger.info('[ShiftProvider.close] end');
  }
}

extension ShiftSessionModelX on ShiftSessionModel? {
  bool get isOpen => this?.status == ShiftStatus.open;

  ShiftSessionModel get requiredOpen {
    if (isOpen) return this!;
    throw AppException(msg: "Shift session is not open");
  }
}
