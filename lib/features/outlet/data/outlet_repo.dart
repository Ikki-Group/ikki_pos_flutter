import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/shared_prefs.dart';
import '../../../core/logger/talker_logger.dart';
import '../../../utils/json.dart';
import '../../app/model/device_model.dart';
import '../model/outlet_model.dart';
import '../model/outlet_state.dart';

part 'outlet_repo.g.dart';

@Riverpod(keepAlive: true)
OutletRepo outletRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  return OutletRepoImpl(sp: sp);
}

abstract class OutletRepo {
  Future<OutletState?> getLocalState();
  Future<bool> syncLocalState(OutletModel outlet, DeviceModel device);
  Future<bool> removeLocalState();
}

class OutletRepoImpl implements OutletRepo {
  OutletRepoImpl({required this.sp});

  final SharedPreferences sp;

  @override
  Future<OutletState?> getLocalState() async {
    logger.info('[OutletRepo.getLocalState] start');

    final raw = sp.getString(SharedPrefsKeys.outletState.key);
    if (raw == null) {
      logger.info('[OutletRepo.getLocalState] outlet state not found');
      return null;
    }

    final json = posJsonDecode(raw);
    if (json == null) {
      logger.info('[OutletRepo.getLocalState] outlet state is not valid');
      return null;
    }

    logger.info('[OutletRepo.getLocalState] outlet state found');
    return OutletState.fromJson(json);
  }

  @override
  Future<bool> removeLocalState() async {
    logger.info('[OutletRepo.removeLocalState] start');
    final result = await sp.remove(SharedPrefsKeys.outletState.key);

    logger.info('[OutletRepo.removeLocalState] result: $result');
    return result;
  }

  @override
  Future<bool> syncLocalState(OutletModel outlet, DeviceModel device) async {
    logger.info('[OutletRepo.syncLocalState] start');

    final state = OutletState(
      outlet: outlet,
      device: device,
    );

    final result = await sp.setString(SharedPrefsKeys.outletState.key, posJsonEncode(state.toJson()));
    logger.info('[OutletRepo.syncLocalState] result: $result');

    return result;
  }
}
