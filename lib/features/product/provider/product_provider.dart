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

  Future<ProductState> load() async {
    state = await ref.read(productRepoProvider).getState();
    return state;
  }

  Future<ProductState> syncData(List<ProductModel> products, List<ProductCategoryModel> categories) async {
    await ref.read(productRepoProvider).syncState(products, categories);
    await load();
    return state;
  }
}
