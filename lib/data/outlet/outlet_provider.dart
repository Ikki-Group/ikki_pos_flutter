import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/utils/talker.dart';
import '../user/user_model.dart';
import 'outlet_model.dart';
import 'outlet_repo.dart';
import 'outlet_session_repo.dart';
import 'outlet_util.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  @override
  OutletStateModel build() => null!;

  Future<bool> load() async {
    try {
      final outlet = await ref.read(outletRepoProvider).getState();
      state = outlet;
      return true;
    } catch (e) {
      return false;
    }
  }

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
}
