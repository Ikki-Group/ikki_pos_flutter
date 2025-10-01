import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth_repo.dart';
import '../../../utils/result.dart';

part 'auth_device_provider.g.dart';

@Riverpod()
class Authenticate extends _$Authenticate {
  @override
  FutureOr<bool> build() => true;

  Future<bool> call(String code) async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepoProvider).authenticate(code);
    state = const AsyncData(true);
    return result.when(success: (_) => true, failure: (e) => false);
  }
}
