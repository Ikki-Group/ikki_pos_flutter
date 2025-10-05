import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/sembast.dart';
import '../../../core/db/shared_prefs.dart';
import '../../../shared/utils/talker.dart';
import '../../auth/provider/auth_token_provider.dart';
import '../../auth/provider/user_provider.dart';
import '../../outlet/provider/outlet_provider.dart';
import '../../printer/provider/printer_provider.dart';
import '../../product/provider/product_provider.dart';
import '../data/sync_repo.dart';
import '../model/app_state.dart';

part "app_provider.g.dart";

@Riverpod(keepAlive: true)
class App extends _$App {
  @override
  AppState build() => const AppState(
    isLoading: true,
    isAuthenticated: false,
  );

  Future<AppState> init() async {
    final token = await ref.read(authTokenProvider.notifier).load();
    await ref.read(printerProvider.notifier).load();

    try {
      if (token != null && token.isNotEmpty) {
        // await ref.read(userRepoProvider).getData();
        // await ref.read(outletProvider.notifier).load();

        await hardSync();
        state = state.copyWith(isAuthenticated: true, isLoading: false);
      }
    } catch (e) {
      talker.error(e.toString());
      state = state.copyWith(isAuthenticated: false, isLoading: false);
    }

    return state;
  }

  Future<void> hardSync() async {
    // Hard sync
    final data = await ref.read(syncRepoProvider).deviceSync();

    await ref.read(outletProvider.notifier).syncData(data.outlet, data.device);
    await ref.read(userProvider.notifier).syncLocal(data.accounts);
    await ref.read(productProvider.notifier).syncData(data.products, data.categories);
  }

  Future<void> logout() async {
    await ref.read(sembastServiceProvider).drop();
    await ref.read(sharedPrefsProvider).clear();
  }
}
