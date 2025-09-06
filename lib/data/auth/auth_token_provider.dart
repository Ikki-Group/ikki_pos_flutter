import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cart/cart_repo.dart';
import 'auth_repo.dart';

part 'auth_token_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;

  Future<String?> load() async {
    state = await ref.read(authRepoProvider).getToken();
    return state;
  }

  Future<void> logout() async {
    await ref.read(authRepoProvider).logout();
    await ref.read(cartRepoProvider).unsafeClear();
    state = null;
  }
}
