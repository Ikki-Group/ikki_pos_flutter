import 'package:ikki_pos_flutter/data/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  User? build() {
    return null;
  }

  Future<void> setUser(User user) async {
    state = user.copyWith();
  }
}
