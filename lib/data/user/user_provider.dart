import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_model.dart';
import 'user_repo.dart';

part 'user_provider.g.dart';

@riverpod
FutureOr<List<UserModel>> userList(Ref ref) async {
  final users = await ref.watch(userRepoProvider).fetch();
  return users;
}

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  UserModel? build() => null;

  UserModel requiredUser() {
    if (state == null) throw Exception('[CurrentUser] User is null');
    return state!;
  }

  Future<void> setUser(UserModel user) async {
    state = user;
  }

  Future<void> logout() async {
    state = null;
  }
}
