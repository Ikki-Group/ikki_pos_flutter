import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../router/app_router.dart';
import '../provider/app_provider.dart';

part 'app_splash_controller.g.dart';

@riverpod
FutureOr<AppRouter> splash(Ref ref) async {
  ref.watch(appProvider);

  final appState = await ref.read(appProvider.notifier).init();
  if (appState.isAuthenticated) return AppRouter.userSelect;
  return AppRouter.authDevice;
}
