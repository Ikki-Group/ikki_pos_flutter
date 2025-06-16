import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/shared/providers/app_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.freezed.dart';
part 'app_provider.g.dart';

@freezed
sealed class AppState with _$AppState {
  const factory AppState.loading() = Loading;
  const factory AppState.ready() = Ready;
}

@Riverpod(keepAlive: true)
class App extends _$App {
  @override
  AppState build() {
    init();
    return AppState.loading();
  }

  Future<void> init() async {
    final token = await ref.read(appTokenProvider.future);
    print('token: $token');
    state = AppState.ready();
  }
}
