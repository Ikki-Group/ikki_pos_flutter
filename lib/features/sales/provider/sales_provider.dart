import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cart/domain/cart_state.dart';
import '../data/sales_repo.dart';

part 'sales_provider.g.dart';

abstract class SalesNotifier {
  Future<bool> save(CartState sales);
  Future<void> unsafeClear();
}

@Riverpod(keepAlive: true)
class Sales extends _$Sales implements SalesNotifier {
  @override
  FutureOr<List<CartState>> build() async {
    final sales = await ref.watch(salesRepoProvider).list();
    return sales;
  }

  @override
  Future<bool> save(CartState sales) async {
    await ref.watch(salesRepoProvider).save(sales);
    ref.invalidateSelf(asReload: true);
    return true;
  }

  @override
  Future<void> unsafeClear() async {
    await ref.watch(salesRepoProvider).unsafeClear();
    ref.invalidateSelf(asReload: true);
  }
}
