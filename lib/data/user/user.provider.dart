import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user.model.dart';

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
