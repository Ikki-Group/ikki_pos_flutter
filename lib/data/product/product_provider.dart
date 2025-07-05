import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/data/product/product_model.dart';
import 'package:ikki_pos_flutter/data/product/product_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.freezed.dart';
part 'product_provider.g.dart';

@freezed
abstract class ProductDataState with _$ProductDataState {
  const factory ProductDataState({
    required List<ProductCategory> categories,
    required List<Product> products,
  }) = _ProductDataState;
}

@Riverpod(keepAlive: true)
class ProductData extends _$ProductData {
  @override
  ProductDataState build() {
    unawaited(load());
    return ProductDataState(
      categories: [],
      products: [],
    );
  }

  Future<void> load() async {
    final repo = ref.read(productRepoProvider);
    final products = await repo.getProducts();
    var categories = await repo.getCategories();

    // Most efficient - single pass grouping
    final categoriesCount = products
        .groupListsBy((product) => product.categoryId)
        .map((key, value) => MapEntry(key, value.length));

    categories = categories.map((category) {
      return category.copyWith(productCount: categoriesCount[category.id] ?? 0);
    }).toList();

    state = state.copyWith(categories: categories, products: products);
  }
}
