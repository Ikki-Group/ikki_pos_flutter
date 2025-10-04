import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../sales/data/sales_repo.dart';
import '../data/auth_repo.dart';

part 'auth_token_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;

  Future<String?> load() async {
    state = await ref.read(authRepoProvider).getToken();
    return state;
  }

  Future<bool> logout() async {
    await ref.read(authRepoProvider).logout();
    await ref.read(salesRepoProvider).logout();
    state = null;
    return true;
  }
}
