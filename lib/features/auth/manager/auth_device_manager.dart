import 'package:ikki_pos_flutter/data/auth/auth_model.dart';
import 'package:ikki_pos_flutter/data/auth/auth_repo.dart';
import 'package:ikki_pos_flutter/shared/providers/app_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_device_manager.g.dart';

@riverpod
class AuthDeviceManager extends _$AuthDeviceManager {
  @override
  AsyncValue<String?> build() {
    return AsyncValue.data(null);
  }

  authenticate(String code) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(authRepoProvider)
        .authenticate(
          AuthDeviceReq(key: code, deviceInfo: await DeviceInfoDto.current()),
        );

    res.fold(
      (e) {
        state = AsyncValue.error(e.msg, StackTrace.current);
      },
      (r) async {
        final token = r.token;
        await ref.read(appTokenProvider.notifier).setToken(token);
        state = AsyncValue.data(token);
      },
    );
  }
}
