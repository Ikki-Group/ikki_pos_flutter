import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/product_repo.dart';
import '../data/product_state.dart';
import '../model/product_model.dart';

part 'product_provider.g.dart';

@Riverpod(keepAlive: true)
class Product extends _$Product {
  @override
  ProductState build() {
    unawaited(load());
    return ProductState(products: [], categories: []);
  }

  Future<ProductState?> load() async {
    final local = await ref.read(productRepoProvider).getLocal();
    if (local != null) {
      state = local;
    }
    return local;
  }

  Future<ProductState> syncData(List<ProductModel> products, List<ProductCategoryModel> categories) async {
    await ref.read(productRepoProvider).syncLocal(products, categories);
    await load();
    return state;
  }
}
