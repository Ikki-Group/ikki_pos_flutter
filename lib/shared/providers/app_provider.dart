import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.freezed.dart';
part 'app_provider.g.dart';

@freezed
sealed class AppState with _$AppState {
  const factory AppState.loading() = _Loading;
  const factory AppState.ready() = _Ready;
}

@Riverpod(keepAlive: true)
class App {
  @override
  Future<AppState> build() async {
    return const AppState.loading();
  }
}
