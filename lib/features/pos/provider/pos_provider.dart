import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_repo.dart';

part 'pos_provider.g.dart';

@riverpod
FutureOr<List<Cart>> posCartList(Ref ref) async {
  return ref.watch(cartRepoProvider).list();
}

enum PosTabItem {
  process(label: 'Process'),
  done(label: 'Success'),
  canceled(label: 'Void');

  const PosTabItem({required this.label});

  final String label;
}
