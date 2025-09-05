import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_model.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  UserModel? build() => null;

  UserModel setUser(UserModel user) => state = user;

  void logout() => state = null;
}
