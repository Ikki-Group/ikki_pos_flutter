import 'package:ikki_pos_flutter/data/product/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "cart_selection_manager.g.dart";

@riverpod
class SearchProductNotifier extends _$SearchProductNotifier {
  @override
  String build() => '';

  void setSearch(String value) => state = value;
}

@riverpod
class CategoryFilterNotifier extends _$CategoryFilterNotifier {
  @override
  ProductCategory build() => ProductCategory(
    id: '',
    outletId: '',
    name: '',
    productCount: 0,
  );

  void setFilter(ProductCategory value) => state = value;
}
