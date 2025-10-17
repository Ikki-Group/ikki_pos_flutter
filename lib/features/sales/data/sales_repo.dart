import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';

import '../../../core/db/sembast.dart';
import '../../../utils/json.dart';
import '../../cart/domain/cart_state.dart';

part 'sales_repo.g.dart';

@Riverpod(keepAlive: true)
SalesRepo salesRepo(Ref ref) {
  final ss = ref.watch(sembastServiceProvider);
  return SalesRepoImpl(ss: ss);
}

abstract class SalesRepo {
  Future<List<CartState>> list();
  Future<CartState?> get(String id);

  Future<void> save(CartState sales);
  Future<void> update(CartState sales);

  Future<void> logout();
}

class SalesRepoImpl implements SalesRepo {
  SalesRepoImpl({required this.ss});

  final SembastService ss;
  final StoreRef store = StoreRef('sales');

  @override
  Future<List<CartState>> list() async {
    final raw = await store.find(ss.db);
    var sales = raw.map((e) => CartState.fromJson(e.value! as Json)).toList();
    sales.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sales;
  }

  @override
  Future<CartState?> get(String id) async {
    final sales = await store.record(id).get(ss.db);
    return sales != null ? CartState.fromJson(sales as Json) : null;
  }

  @override
  Future<void> save(CartState sales) async {
    await store.record(sales.id).put(ss.db, sales.toJson());
  }

  @override
  Future<void> update(CartState sales) async {
    await store.record(sales.id).update(ss.db, sales);
  }

  @override
  Future<void> logout() async {
    await store.delete(ss.db);
    ss.db.dropAll();
  }
}
