import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../router/ikki_router.dart';
import '../provider/app_provider.dart';

part 'app_splash_controller.g.dart';

@riverpod
FutureOr<IkkiRouter> splash(Ref ref) async {
  ref.read(appProvider);

  await Future.delayed(const Duration(seconds: 1));
  final app = await ref.read(appProvider.notifier).init();
  if (app.isAuthenticated) return IkkiRouter.userSelect;
  return IkkiRouter.authDevice;
}
