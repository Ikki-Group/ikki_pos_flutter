import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../router/app_router.dart';
import '../provider/app_provider.dart';

part 'app_splash_controller.g.dart';

@riverpod
FutureOr<AppRouter> splash(Ref ref) async {
  ref.read(appProvider);

  // await Future.delayed(const Duration(seconds: 1));
  final app = await ref.read(appProvider.notifier).init();
  if (app.isAuthenticated) return AppRouter.userSelect;
  return AppRouter.authDevice;
}
