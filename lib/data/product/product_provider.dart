import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'product.model.dart';
import 'product_repo.dart';

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
    return const ProductDataState(
      categories: [],
      products: [],
    );
  }

  Future<void> load() async {
    final repo = ref.read(productRepoProvider);
    final products = await repo.getProducts();
    final categories = await repo.getCategories();

    final cc = <String, int>{
      ProductCategory.kIdAll: 0,
      ProductCategory.kIdFavorite: 0,
    };

    for (final product in products) {
      cc.update(
        product.categoryId,
        (o) => o + 1,
        ifAbsent: () => 1,
      );

      cc.update(ProductCategory.kIdAll, (o) => o + 1);
      if (product.isFavorite) {
        cc.update(
          ProductCategory.kIdFavorite,
          (o) => o + 1,
        );
      }
    }

    state = state.copyWith(
      products: products,
      categories: categories
          .map(
            (category) => category.copyWith(
              productCount: cc[category.id] ?? 0,
            ),
          )
          .toList(),
    );
  }
}
