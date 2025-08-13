import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/db/shared_prefs.dart';

part 'auth_token_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  FutureOr<String?> build() async {
    return getToken();
  }

  Future<void> setToken(String token) async {
    await ref.read(sharedPrefsProvider).setString(SharedPrefsKeys.authToken.key, token);
    state = AsyncValue.data(token);
  }

  Future<String?> getToken() async {
    final token = ref.read(sharedPrefsProvider).getString(SharedPrefsKeys.authToken.key);
    state = AsyncValue.data(token);
    return token;
  }
}
