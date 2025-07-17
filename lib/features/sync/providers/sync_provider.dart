import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/outlet/outlet.provider.dart';
import '../../../data/user/user.repo.dart';

part 'sync_provider.g.dart';

@riverpod
FutureOr<void> syncGlobal(Ref ref) async {
  await ref.watch(outletProvider.future);
  await ref.watch(userRepoProvider).fetch();
}
