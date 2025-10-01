import 'package:intl/intl.dart';
import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/utils/talker.dart';
import '../user/user_model.dart';
import 'outlet_model.dart';
import 'outlet_repo.dart';
import 'outlet_session_repo.dart';
import 'outlet_util.dart';

part 'outlet_provider.g.dart';

abstract class OutletProviderContract {
  Future<bool> load();

  // Shift management
  Future<bool> open({required int cash, required UserModel user, String note = ''});
  Future<bool> close({required int cash, required UserModel user, String note = ''});

  // Receipt code
  String getReceiptCode();
  Future<bool> incrementReceiptCode();

  // Sales
  Future<bool> addSalesSuccess(double netSales, double cash);
  Future<bool> addSalesFail();
}

@Riverpod(keepAlive: true, name: 'outletProvider')
class OutletNotifier extends _$OutletNotifier implements OutletProviderContract {
  @override
  OutletStateModel build() {
    load();
    return null!;
  }

  @override
  Future<bool> load() async {
    try {
      final outlet = await ref.read(outletRepoProvider).getState();
      state = outlet;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> open({
    required int cash,
    required UserModel user,
    String note = '',
  }) async {
    if (state.isOpen) throw Exception('Outlet session is already open');

    final open = OutletSessionInfo(
      at: DateTime.now().toIso8601String(),
      by: user.id,
      cashBalance: cash,
      note: note,
    );

    state = state.copyWith(
      session: OutletSessionModel(
        id: ObjectId().hexString,
        open: open,
      ),
    );

    await ref.read(outletRepoProvider).saveState(state);
    return true;
  }

  @override
  Future<bool> close({
    required int cash,
    required UserModel user,
    String note = '',
  }) async {
    if (!state.isOpen || state.session == null) throw Exception('Outlet session is not open');

    final session = state.session!.copyWith(
      close: OutletSessionInfo(
        at: DateTime.now().toIso8601String(),
        by: user.id,
        cashBalance: cash,
        note: note,
      ),
    );

    talker.info('[Outlet] close $session');
    await ref.read(outletSessionRepoProvider).saveLocal(session);

    state = state.copyWith(session: null);
    await ref.read(outletRepoProvider).saveState(state);
    return true;
  }

  @override
  String getReceiptCode() {
    final session = state.session;
    if (session == null) throw Exception('Outlet session is not open');

    final outletCode = state.outlet.code;
    final deviceCode = state.device.code;
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final queue = session.queue;

    // Example
    // ICO/1/20230101/1

    return '$outletCode/$deviceCode/$date/$queue';
  }

  @override
  Future<bool> incrementReceiptCode() async {
    final session = state.session;
    if (session == null) throw Exception('Outlet session is not open');

    final queue = session.queue + 1;
    final newState = state.copyWith.session!(queue: queue);

    await ref.read(outletRepoProvider).saveState(newState);
    state = newState;

    return true;
  }

  @override
  Future<bool> addSalesFail() async {
    state = state.copyWith(session: state.session!.copyWith(trxFail: state.session!.trxFail + 1));
    return ref.read(outletRepoProvider).saveState(state);
  }

  @override
  Future<bool> addSalesSuccess(double netSales, double cash) {
    state = state.copyWith(
      session: state.session!.copyWith(
        trxSuccess: state.session!.trxSuccess + 1,
        netSales: state.session!.netSales + netSales,
        cash: state.session!.cash + cash,
      ),
    );
    return ref.read(outletRepoProvider).saveState(state);
  }
}
