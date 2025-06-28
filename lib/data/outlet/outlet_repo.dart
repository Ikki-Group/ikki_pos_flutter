import 'dart:convert';

import 'package:ikki_pos_flutter/core/db/shared_prefs.dart';
import 'package:ikki_pos_flutter/core/network/api_client.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'outlet_repo.g.dart';

@riverpod
OutletRepo outletRepo(ref) {
  final api = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPrefsProvider);
  return OutletRepo(api: api, sharedPrefs: prefs);
}

class OutletRepo {
  final ApiClient api;
  final SharedPreferences sharedPrefs;

  OutletRepo({required this.api, required this.sharedPrefs});

  Future<OutletModel> getRemote() async {
    OutletModel outlet = OutletModel.getMock();
    await saveState(OutletState(outlet: outlet));
    return outlet;
  }

  Future<OutletState?> getState() async {
    final state = sharedPrefs.getString(SharedPrefsKeys.outlet.key);
    print("state: $state");
    if (state == null) {
      OutletModel outlet = await getRemote();
      return OutletState(outlet: outlet);
    }

    return OutletState.fromJson(jsonDecode(state));
  }

  Future<bool> saveState(OutletState state) async {
    await sharedPrefs.setString(SharedPrefsKeys.outlet.key, jsonEncode(state));
    return true;
  }
}
