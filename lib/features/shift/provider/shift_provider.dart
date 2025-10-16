import 'dart:async';

import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

import '../../../core/config/app_constant.dart';
import '../../../core/logger/talker_logger.dart';
import '../../../utils/app_toast.dart';
import '../../../utils/exception.dart';
import '../../../utils/result.dart';
import '../../cart/model/cart_state.dart';
import '../../outlet/provider/outlet_provider.dart';
import '../data/shift_repo.dart';
import '../model/shift_session_model.dart';
import '../model/shift_status.dart';

part 'shift_provider.g.dart';

abstract class ShiftNotifier {
  Future<void> load();
  Future<void> loadLocal();
  Future<void> syncLocal(ShiftSessionModel? session);

  String generateReceiptCode();
  Future<void> increaseQueue();

  Future<bool> open(String outletId, ShiftSessionInfo open);
  Future<void> close(String outletId, ShiftSessionInfo close);

  // Handle Sales
  Future<void> onSalesSaved({
    required CartState cart,
    required CartStatus lastStatus,
    List<CartPayment>? newPayments,
  });
}

@Riverpod(keepAlive: true)
class Shift extends _$Shift implements ShiftNotifier {
  @override
  ShiftSessionModel? build() {
    unawaited(load());
    return null;
  }

  ShiftRepo get _repo => ref.read(shiftRepoProvider);

  @override
  Future<void> load() async {
    final outletId = ref.read(outletProvider).outlet.id;

    ShiftSessionModel? shift;
    final remote = await _repo.getRemoteState(outletId);
    remote.when(
      success: (value) => shift = value,
      failure: (_) => shift = null,
    );

    _repo.syncLocalState(shift);
    state = shift;
  }

  @override
  Future<void> loadLocal() async {
    logger.info('[ShiftProvider.loadLocal] start');
    state = await _repo.getLocalState();
  }

  @override
  Future<void> syncLocal(
    ShiftSessionModel? session,
  ) async {
    logger.info('[ShiftProvider.syncLocal] start');
    await _repo.syncLocalState(session);
    state = session;
    logger.info('[ShiftProvider.syncLocal] end');
  }

  @override
  String generateReceiptCode() {
    final dc = ref.read(outletProvider).device.code;
    final session = state.requiredOpen;
    final yyyyMMdd = DateFormat("yyyyMMdd").format(DateTime.now());
    final queue = session.queue + 1;
    final rc = "$dc/${session.code}/$yyyyMMdd/$queue";
    return rc;
  }

  @override
  Future<void> increaseQueue() async {
    var session = state.requiredOpen;
    session = session.copyWith(queue: session.queue + 1);
    await _repo.syncLocalState(session);
  }

  @override
  Future<bool> open(
    String outletId,
    ShiftSessionInfo open,
  ) async {
    logger.info('[ShiftProvider.open] start');
    await _repo.open(outletId, open);
    await load();
    logger.info('[ShiftProvider.open] end');
    return true;
  }

  @override
  Future<void> close(
    String outletId,
    ShiftSessionInfo closeInfo,
  ) async {
    try {
      logger.info('[ShiftProvider.close] start');
      await _repo.close(outletId, closeInfo);
      await load();
      logger.info('[ShiftProvider.close] end');
    } catch (e) {
      AppToast.show('Gagal menutup toko', type: ToastificationType.error);
    }
  }

  @override
  Future<void> onSalesSaved({
    required CartState cart,
    required CartStatus lastStatus,
    List<CartPayment>? newPayments,
  }) {
    throw UnimplementedError();
  }
}

extension ShiftSessionModelX on ShiftSessionModel? {
  bool get isOpen => this?.status == ShiftStatus.open;

  ShiftSessionModel get requiredOpen {
    if (isOpen) return this!;
    throw AppException(msg: "Shift session is not open");
  }
}
