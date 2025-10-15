import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError();
}

enum SharedPrefsKeys {
  authToken,
  outletState,
  shiftSession,
  users,
  products,
  paymentOptions,
  printers
  //
  ;

  String get key => toString().replaceAll('SharedPrefsKeys.', '');
}
