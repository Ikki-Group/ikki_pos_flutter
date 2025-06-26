import 'package:ikki_pos_flutter/data/user/model.dart';
import 'package:ikki_pos_flutter/data/user/util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo.g.dart';

@riverpod
UserRepo userRepo(ref) {
  return UserRepo();
}

class UserRepo {
  List<User> data() {
    return kMockUsers;
  }

  Future<List<User>> load() async {
    return kMockUsers;
  }
}
