import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth_token_provider.dart';
import '../../../data/cart/cart_provider.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/printer/printer_provider.dart';
import '../../../data/product/product.provider.dart';
import '../../../data/user/user_repo.dart';

part 'sync_provider.g.dart';

@riverpod
FutureOr<bool> syncGlobal(Ref ref) async {
  // ignore: inference_failure_on_instance_creation
  await Future.delayed(const Duration(seconds: 5));

  // Check token is valid
  final token = await ref.watch(authTokenProvider.notifier).load();
  if (token == null || token.isEmpty) return false;

  // Printer
  final printerNotifier = ref.watch(printerStateProvider.notifier);
  await printerNotifier.requestBluetoothPermissions();
  await printerNotifier.load();

  // Ensure required data is loaded
  await ref.watch(outletProvider.notifier).load();
  await ref.watch(userRepoProvider).getLocal();
  await ref.watch(cartDataProvider.notifier).load();
  await ref.watch(productProvider.future);
  return true;
}
