import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'product.model.dart';
import 'product.repo.dart';

part 'product.provider.g.dart';

@riverpod
FutureOr<ProductState> product(Ref ref) async {
  return ref.watch(productRepoProvider).getLocal();
}
