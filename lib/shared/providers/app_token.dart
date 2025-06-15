import 'package:ikki_pos_flutter/core/db/shared_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_token.g.dart';

@Riverpod(keepAlive: true)
class AppToken extends _$AppToken {
  @override
  Future<String?> build() async {
    final token = await getToken();
    return token;
  }

  Future<void> setToken(String token) async {
    await ref
        .read(sharedPrefsProvider.future)
        .then((sp) => sp.setString(SharedPrefsKeys.authToken.key, token));
    state = AsyncValue.data(token);
  }

  Future<String?> getToken() async {
    final token = await ref
        .read(sharedPrefsProvider.future)
        .then((sp) => sp.getString(SharedPrefsKeys.authToken.key));

    state = AsyncValue.data(token);
    return token;
  }
}
