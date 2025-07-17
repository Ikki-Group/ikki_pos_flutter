import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth.model.dart';
import '../../../data/auth/auth.provider.dart';
import '../../../data/auth/auth.repo.dart';

part 'auth_device_provider.g.dart';

@riverpod
class AuthDevice extends _$AuthDevice {
  @override
  FutureOr<String?> build() => null;

  Future<void> authenticate(String code) async {
    try {
      state = const AsyncValue.loading();
      final request = AuthRequest(
        key: code,
        deviceInfo: await ref.read(authRepoProvider).getDeviceInfo(),
      );
      final res = await ref.read(authRepoProvider).authenticateMock(request);
      final token = res.token;
      await ref.read(authTokenProvider.notifier).setToken(token);
      ref.invalidate(authTokenProvider);
      state = AsyncValue.data(res.token);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
