import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/sync/sync_repo.dart';

part 'setting_device_manager.g.dart';

@Riverpod(name: 'settingDeviceManager')
class SettingDeviceManager extends _$SettingDeviceManager {
  @override
  FutureOr<void> build() {}

  Future<void> syncMainData() async {
    final res = await ref.read(syncRepoProvider).syncMainData();
  }
}
