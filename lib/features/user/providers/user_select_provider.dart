import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/user/user_model.dart';
import '../../../data/user/user_repo.dart';

part 'user_select_provider.g.dart';

@riverpod
FutureOr<List<UserModel>> userList(Ref ref) async {
  final users = await ref.watch(userRepoProvider).getLocal();
  return users;
}
