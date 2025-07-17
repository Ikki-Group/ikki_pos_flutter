import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/api_client.dart';
import 'outlet.model.dart';

part 'outlet_repo.g.dart';

@riverpod
OutletRepo outletRepo(Ref ref) {
  final api = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  return OutletRepo(api: api, sharedPrefs: prefs);
}

class OutletRepo {
  OutletRepo({required this.api, required this.sharedPrefs});
  final ApiClient api;
  final SharedPreferences sharedPrefs;

  Future<OutletModel> getRemote() async {
    final outlet = OutletModel.getMock();
    await saveState(OutletState(outlet: outlet));
    return outlet;
  }

  Future<OutletState?> getState() async {
    final state = sharedPrefs.getString(SharedPrefsKeys.outlet.key);
    if (state == null) {
      final outlet = await getRemote();
      return OutletState(outlet: outlet);
    }

    return OutletState.fromJson(jsonDecode(state) as Map<String, dynamic>);
  }

  Future<bool> saveState(OutletState state) async {
    await sharedPrefs.setString(SharedPrefsKeys.outlet.key, jsonEncode(state));
    return true;
  }
}
