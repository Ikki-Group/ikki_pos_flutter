import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/shared_prefs.dart';
import '../../../shared/utils/talker.dart';
import '../../../utils/json.dart';
import '../../app/model/device_model.dart';
import '../model/outlet_model.dart';
import 'outlet_state.dart';

part 'outlet_repo.g.dart';

@Riverpod(keepAlive: true)
OutletRepo outletRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  return OutletRepoImpl(sp: sp, ref: ref);
}

abstract class OutletRepo {
  Future<OutletState> getState();
  Future<bool> saveState(OutletState state);

  Future<bool> syncState(OutletModel outlet, DeviceModel device);
}

class OutletRepoImpl implements OutletRepo {
  OutletRepoImpl({required this.sp, required this.ref});

  final SharedPreferences sp;
  final Ref ref;

  @override
  Future<OutletState> getState() async {
    logger.info('[OutletRepo] getState');

    OutletState state;
    final raw = sp.getString(SharedPrefsKeys.outletState.key);
    if (raw == null) {
      throw Exception('Outlet state not found, ensure to initialize');
    }
    final json = posJsonDecode(raw);
    if (json == null) {
      throw Exception('Outlet state is not valid');
    }
    state = OutletState.fromJson(json);

    return state;
  }

  @override
  Future<bool> saveState(OutletState state) {
    talker.info('[OutletRepo] saveState $state');
    return sp.setString(SharedPrefsKeys.outletState.key, jsonEncode(state));
  }

  @override
  Future<bool> syncState(OutletModel outlet, DeviceModel device) async {
    var state = await getState().catchError((e) => OutletState(outlet: outlet, device: device));
    state = state.copyWith(device: device, outlet: outlet);
    return saveState(state);
  }
}
