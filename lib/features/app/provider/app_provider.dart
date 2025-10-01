import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/provider/auth_token_provider.dart';
import '../../auth/provider/user_provider.dart';
import '../../outlet/provider/outlet_provider.dart';
import '../data/sync_repo.dart';

part "app_provider.freezed.dart";
part "app_provider.g.dart";

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(false) bool isAuthenticated,
    @Default(true) bool isLoading,
  }) = _AppState;
}

@Riverpod(keepAlive: true)
class App extends _$App {
  @override
  AppState build() => AppState();

  Future<AppState> init() async {
    state = AppState(isLoading: true);

    final token = await ref.read(authTokenProvider.notifier).load();

    if (token != null && token.isNotEmpty) {
      // await ref.read(userRepoProvider).getData();
      // await ref.read(outletProvider.notifier).load();

      // Hard sync
      final mainData = await ref.read(syncRepoProvider).fetchMainData();

      await ref.read(outletProvider.notifier).syncData(mainData.outlet, mainData.device);
      await ref.read(userProvider.notifier).syncLocal(mainData.users);

      state = state.copyWith(isAuthenticated: true);
    }

    return state;
  }
}
