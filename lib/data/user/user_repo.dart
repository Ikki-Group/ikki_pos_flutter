import 'package:ikki_pos_flutter/data/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repo.g.dart';

@riverpod
UserRepo userRepo(ref) {
  return UserRepo();
}

class UserRepo {
  List<User> list() {
    return User.getMock();
  }
}
