import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'cart_model.dart';
import 'cart_repo.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartData extends _$CartData {
  @override
  List<Cart> build() {
    load();
    return [];
  }

  Future<void> load() async {
    state = await ref.read(cartRepoProvider).list();
  }

  Future<void> save(Cart cart) async {
    await ref.read(cartRepoProvider).save(cart);
    await load();
  }
}
