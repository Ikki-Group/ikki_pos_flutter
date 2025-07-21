import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user.model.dart';
import 'user.repo.dart';

part 'user.provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  UserModel? build() {
    return null;
  }

  Future<void> setUser(UserModel user) async {
    state = user;
  }

  Future<void> logout() async {
    state = null;
  }
}

@riverpod
FutureOr<List<UserModel>> userList(Ref ref) async {
  final users = await ref.watch(userRepoProvider).fetch();
  return users;
}
