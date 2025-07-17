import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'outlet.model.dart';
import 'outlet.repo.dart';

part 'outlet.provider.g.dart';

@riverpod
FutureOr<OutletModel> outlet(Ref ref) async {
  return ref.watch(outletRepoProvider).getLocal();
}
