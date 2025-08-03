import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_repo.dart';

part 'pos_provider.g.dart';

@riverpod
FutureOr<List<Cart>> posCartList(Ref ref) async {
  final cartList = await ref.watch(cartRepoProvider).list();
  return cartList.sortedBy((c) => c.createdAt).toList();
}

enum PosTabItem {
  all(label: 'Semua'),
  cashier(label: 'Kasir'),
  online(label: 'Online');

  const PosTabItem({required this.label});

  final String label;
}
