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

  UserModel requireUser() {
    final user = state;
    if (user == null) {
      throw Exception('[CurrentUser] User is null');
    }
    return user;
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
