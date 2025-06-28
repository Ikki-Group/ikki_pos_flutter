import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/shared/providers/app_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.freezed.dart';
part 'app_provider.g.dart';

@freezed
sealed class AppState with _$AppState {
  const AppState._();

  const factory AppState.loading() = Loading;
  const factory AppState.ready({
    required bool isAuthenticated,
  }) = Ready;
}

@Riverpod(keepAlive: true)
class App extends _$App {
  @override
  AppState build() {
    load();
    return AppState.loading();
  }

  Future<void> load() async {
    final token = await ref.read(appTokenProvider.future);

    final isAuthenticated = token != null;

    if (isAuthenticated) {
      final result = await ref.read(outletNotifierProvider.notifier).load();
      if (!result) {
        print("Error loading outlet");
      }
    }

    state = AppState.ready(isAuthenticated: token != null);
  }
}
