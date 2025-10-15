import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/sembast.dart';
import '../../../core/db/shared_prefs.dart';
import '../../../core/logger/talker_logger.dart';
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

    final isAuthenticated = token != null && token.isNotEmpty;

    if (isAuthenticated) {
      await loadData();
    }

    state = state.copyWith(isAuthenticated: isAuthenticated, isLoading: false);
    return state;
  }

  Future<void> loadData() async {
    logger.info("[App.loadData] start");

    final isLocalReady = await loadLocal();
    if (!isLocalReady) {
      await syncRemoteToLocal();
    }

    logger.info("[App.loadData] end");
  }

  Future<bool> loadLocal() async {
    logger.info("[App.loadLocal] start");

    final outletLoaded = await ref.read(outletProvider.notifier).load() == null;
    final userLoaded = await ref.read(userProvider.notifier).load() == null;
    final productLoaded = await ref.read(productProvider.notifier).load() == null;

    final isLocalReady = outletLoaded && userLoaded && productLoaded;

    if (!isLocalReady) {
      logger.info('Data need to sync, outlet: $outletLoaded, user: $userLoaded, product: $productLoaded');
    }

    return isLocalReady;
  }

  Future<void> syncRemoteToLocal() async {
    logger.info("[App.hardSync] start");

    // Hard sync
    final data = await ref.read(syncRepoProvider).deviceSync();

    await ref.read(outletProvider.notifier).syncData(data.outlet, data.device);
    await ref.read(userProvider.notifier).syncLocal(data.accounts);
    await ref.read(productProvider.notifier).syncData(data.products, data.categories);

    logger.info("[App.hardSync] end");
  }

  Future<void> logout() async {
    await ref.read(sembastServiceProvider).drop();
    await ref.read(sharedPrefsProvider).clear();
  }
}
