import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user.model.dart';

part 'user_repo.g.dart';

@riverpod
UserRepo userRepo(Ref ref) {
  return UserRepo();
}

class UserRepo {
  List<UserModel> list() {
    return List.generate(10, (index) {
      return UserModel(
        id: '$index',
        name: 'Rizqy Nugroho $index',
        email: 'rizqy.nugroho$index@ikki.id',
        pin: '1111',
      );
    });
  }
}
