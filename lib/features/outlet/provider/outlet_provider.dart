import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/model/device_model.dart';
import '../../auth/model/user_model.dart';
import '../data/outlet_repo.dart';
import '../data/outlet_state.dart';
import '../model/outlet_model.dart';
import '../model/shift_status.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  @override
  OutletState build() => OutletState.empty();

  Future<OutletState> load() async {
    state = await ref.read(outletRepoProvider).getState();
    return state;
  }

  Future<OutletState> syncData(OutletModel outlet, DeviceModel device) async {
    await ref.read(outletRepoProvider).syncState(outlet, device);
    await load();
    return state;
  }

  Future<bool> openOutlet(int cash, UserModel user) async {
    if (state.isOpen) throw Exception('Outlet session is already open');

    final outlet = state.outlet;
    final now = DateTime.now().toIso8601String();

    final newState = state.copyWith(
      session: OutletSessionModel(
        id: ObjectId().hexString,
        outletId: outlet.id,
        open: OutletSessionInfo(
          at: now,
          by: user.id,
          balance: cash,
          note: '',
        ),
        status: ShiftStatus.open,
      ),
    );

    await ref.read(outletRepoProvider).saveState(newState);
    state = newState;
    return true;
  }

  Future<void> incrementQueue() async {}
}
