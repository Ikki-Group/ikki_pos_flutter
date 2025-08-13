import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth/auth_token_provider.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/product/product.provider.dart';
import '../../../data/user/user_repo.dart';
import '../../../router/ikki_router.dart';

part 'splash_provider.g.dart';

@riverpod
FutureOr<IkkiRouter> splash(Ref ref) async {
  final token = await ref.watch(authTokenProvider.future);
  if (token != null) {
    await ref.watch(outletProvider.future);
    await ref.watch(userRepoProvider).fetch();
    await ref.watch(productProvider.future);
    return IkkiRouter.userSelect;
  }

  return IkkiRouter.authDevice;
}
