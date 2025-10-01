import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../../shared/utils/talker.dart';
import '../json.dart';
import 'outlet_constant.dart';
import 'outlet_model.dart';

part 'outlet_repo.g.dart';

@Riverpod(keepAlive: true)
OutletRepo outletRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  return OutletRepoImpl(dio: dio, sp: sp, ref: ref);
}

abstract class OutletRepo {
  Future<OutletStateModel> getState();
  Future<bool> saveState(OutletStateModel state);

  Future<bool> syncState(OutletModel outlet, OutletDeviceModel device);
}

class OutletRepoImpl implements OutletRepo {
  OutletRepoImpl({required this.dio, required this.sp, required this.ref});

  final Dio dio;
  final SharedPreferences sp;
  final Ref ref;

  @override
  Future<OutletStateModel> getState() async {
    talker.info('[OutletRepo] getState');

    OutletStateModel state;
    final raw = sp.getString(SharedPrefsKeys.outletState.key);
    if (raw != null) {
      final json = posJsonDecode(raw);
      state = OutletStateModel.fromJson(json);
    } else {
      final outlet = await fetchOutlet();
      state = OutletStateModel(
        outlet: outlet,
        device: _mockDevice,
      );
    }

    return state;
  }

  @override
  Future<bool> saveState(OutletStateModel state) {
    talker.info('[OutletRepo] saveState $state');
    return sp.setString(SharedPrefsKeys.outletState.key, jsonEncode(state));
  }

  @override
  Future<bool> syncState(OutletModel outlet, OutletDeviceModel device) {
    throw UnimplementedError();
  }
}
