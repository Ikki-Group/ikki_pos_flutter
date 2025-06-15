import 'package:ikki_pos_flutter/data/auth/auth_model.dart';
import 'package:ikki_pos_flutter/data/auth/auth_repo.dart';
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

    state = res.fold<AsyncValue<String>>(
      (e) => AsyncValue.error(e.msg, StackTrace.current),
      (r) => AsyncValue.data(r.token),
    );
  }
}
