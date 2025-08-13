import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth_api_model.dart';
import '../../../data/auth/auth_repo.dart';
import '../../../data/auth/auth_token_provider.dart';
import '../../../data/auth/auth_util.dart';

part 'auth_device_provider.g.dart';

@riverpod
class AuthDevice extends _$AuthDevice {
  @override
  FutureOr<String?> build() => null;

  Future<void> authenticate(String code) async {
    try {
      state = const AsyncValue.loading();

      final req = AuthRequest(
        key: code,
        deviceInfo: await getDeviceInfo(),
      );

      final res = await ref.read(authRepoProvider).authenticate(req);
      final token = res.token;

      await ref.read(authTokenProvider.notifier).setToken(token);
      state = AsyncValue.data(res.token);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
