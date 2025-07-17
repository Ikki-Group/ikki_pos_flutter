import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'outlet.model.dart';

part 'outlet.repo.g.dart';

@riverpod
OutletRepo outletRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  return OutletRepo(dio: dio, sp: sp);
}

class OutletRepo {
  OutletRepo({required this.dio, required this.sp});

  final Dio dio;
  final SharedPreferences sp;

  Future<OutletModel> getLocal() async {
    print('[OutletRepo] getLocal');
    OutletModel outlet;
    final outletJson = sp.getString(SharedPrefsKeys.outlet.key);
    if (outletJson != null) {
      outlet = OutletModel.fromJson(jsonDecode(outletJson) as Json);
    } else {
      outlet = await fetch();
    }
    return outlet;
  }

  Future<OutletModel> fetch() async {
    print('[OutletRepo] fetch');
    const outlet = _kMock;
    await save(outlet);
    return outlet;
  }

  Future<bool> save(OutletModel outlet) async {
    return sp.setString(SharedPrefsKeys.outlet.key, jsonEncode(outlet));
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
