import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPrefs(ref) async {
  return SharedPreferences.getInstance();
}

enum SharedPrefsKeys {
  authToken;

  String get key => toString().replaceAll('SharedPrefsKeys.', '');
}
