import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth_token_provider.dart';
import '../../../data/cart/cart_provider.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/printer/printer_provider.dart';
import '../../../data/product/product.provider.dart';
import '../../../data/user/user_repo.dart';
import '../../../router/ikki_router.dart';

part 'splash_provider.g.dart';

@riverpod
FutureOr<IkkiRouter> splash(Ref ref) async {
  final token = await ref.watch(authTokenProvider.notifier).load();

  // Printer
  final printerNotifier = ref.watch(printerStateProvider.notifier);
  await printerNotifier.requestBluetoothPermissions();
  await printerNotifier.load();

  if (token != null) {
    await ref.watch(outletProvider.notifier).load();
    await ref.watch(userRepoProvider).getLocal();
    await ref.watch(cartDataProvider.notifier).load();
    await ref.watch(productProvider.future);
    return IkkiRouter.userSelect;
  }

  return IkkiRouter.authDevice;
}
