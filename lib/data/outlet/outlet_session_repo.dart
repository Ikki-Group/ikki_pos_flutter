import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'outlet_model.dart';

part 'outlet_session_repo.g.dart';

typedef OutletSessionModelList = List<OutletSessionModel>;

@Riverpod(keepAlive: true)
OutletSessionRepo outletSessionRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  return OutletSessionRepo(dio: dio, sp: sp, ref: ref);
}

class OutletSessionRepo {
  OutletSessionRepo({required this.dio, required this.sp, required this.ref});

  final Dio dio;
  final SharedPreferences sp;
  final Ref ref;

  // Local

  Future<OutletSessionModelList> getLocal() async {
    final raw = sp.getString(SharedPrefsKeys.outletSession.key);
    if (raw != null) {
      final json = jsonDecode(raw) as JsonListDynamic;
      return json.map((v) => OutletSessionModel.fromJson(v as Json)).toList();
    }
    return [];
  }

  Future<bool> saveLocal(OutletSessionModel session) async {
    final sessions = await getLocal();
    sessions.add(session);
    return sp.setString(SharedPrefsKeys.outletSession.key, jsonEncode(sessions));
  }
}
