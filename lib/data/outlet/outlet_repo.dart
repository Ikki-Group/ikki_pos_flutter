import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../../shared/utils/talker.dart';
import '../json.dart';
import 'outlet_model.dart';

part 'outlet_repo.g.dart';

@Riverpod(keepAlive: true)
OutletRepo outletRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  return OutletRepo(dio: dio, sp: sp, ref: ref);
}

class OutletRepo {
  OutletRepo({required this.dio, required this.sp, required this.ref});

  final Dio dio;
  final SharedPreferences sp;
  final Ref ref;

  // Local

  Future<OutletModel> getLocal() async {
    talker.info('[OutletRepo] getLocal');

    OutletModel outlet;
    final raw = sp.getString(SharedPrefsKeys.outlet.key);
    if (raw != null) {
      outlet = OutletModel.fromJson(jsonDecode(raw) as Json);
    } else {
      outlet = await fetch();
    }
    return outlet;
  }

  Future<bool> saveLocal(OutletModel outlet) async {
    talker.info('[OutletRepo] saveLocal $outlet');
    return sp.setString(SharedPrefsKeys.outlet.key, jsonEncode(outlet));
  }

  // Remote

  Future<OutletModel> fetch() async {
    talker.info('[OutletRepo] fetch');
    const outlet = _kMock;
    await saveLocal(outlet);
    return outlet;
  }
}

const _kMock = OutletModel(
  id: 'id',
  name: 'Ikki Coffee',
  type: 'type',
  syncAt: '2023-07-01T00:00:00.000Z',
  createdAt: '2023-07-01T00:00:00.000Z',
  updatedAt: '2023-07-01T00:00:00.000Z',
  createdBy: 'createdBy',
  updatedBy: 'updatedBy',
);
