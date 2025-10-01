import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/device_model.dart';
import '../../../model/outlet_model.dart';
import '../data/outlet_repo.dart';
import '../data/outlet_state.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  @override
  OutletState build() {
    // ignore: null_check_always_fails
    return OutletState.empty();
  }

  Future<OutletState> load() async {
    state = await ref.read(outletRepoProvider).getState();
    return state;
  }

  Future<OutletState> syncData(OutletModel outlet, DeviceModel device) async {
    await ref.read(outletRepoProvider).syncState(outlet, device);
    await load();
    return state;
  }
}
