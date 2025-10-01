import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/result.dart';
import '../../data/auth_repo.dart';
import '../../provider/auth_token_provider.dart';

part 'auth_device_controller.g.dart';

@riverpod
class Authenticate extends _$Authenticate {
  @override
  FutureOr<void> build() {}

  Future<Result> run(String code) async {
    state = AsyncLoading();
    final result = await ref.read(authRepoProvider).authenticate(code);
    final _ = ref.refresh(authTokenProvider);

    state = AsyncData(null);
    return result;
  }
}
