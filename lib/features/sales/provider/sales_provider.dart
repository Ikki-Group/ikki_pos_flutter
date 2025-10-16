import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cart/model/cart_state.dart';
import '../data/sales_repo.dart';

part 'sales_provider.g.dart';

@Riverpod(keepAlive: true)
class Sales extends _$Sales {
  @override
  FutureOr<List<CartState>> build() async {
    final sales = await ref.watch(salesRepoProvider).list();
    return sales;
  }

  Future<bool> save(CartState sales) async {
    await ref.watch(salesRepoProvider).save(sales);
    ref.invalidateSelf(asReload: true);
    return true;
  }
}
