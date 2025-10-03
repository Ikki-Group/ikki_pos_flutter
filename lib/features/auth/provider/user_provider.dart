import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/user_repo.dart';
import '../model/user_model.dart';

part 'user_provider.freezed.dart';
part 'user_provider.g.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({
    @Default([]) List<UserModel> users,
    required UserModel selectedUser,
  }) = _UserState;
}

@Riverpod(keepAlive: true)
class User extends _$User {
  @override
  UserState build() {
    return UserState(users: [], selectedUser: UserModel.empty());
  }

  Future<UserState> load() async {
    var users = await ref.read(userRepoProvider).getData();
    state = state.copyWith(users: users, selectedUser: UserModel.empty());
    return state;
  }

  void setUser(UserModel user) {
    state = state.copyWith(selectedUser: user);
  }

  void logout() {
    state = state.copyWith(selectedUser: UserModel.empty());
  }

  Future<void> syncLocal(List<UserModel> users) async {
    await ref.read(userRepoProvider).syncLocal(users);
    await load();
  }
}
