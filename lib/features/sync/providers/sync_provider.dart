import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth_token_provider.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/user/user_repo.dart';

part 'sync_provider.g.dart';

@riverpod
FutureOr<bool> syncGlobal(Ref ref) async {
  await ref.watch(authTokenProvider.future);
  // ignore: inference_failure_on_instance_creation
  await Future.delayed(const Duration(seconds: 5));
  await ref.watch(outletProvider.notifier).load();
  await ref.watch(userRepoProvider).getLocal();
  return true;
}
