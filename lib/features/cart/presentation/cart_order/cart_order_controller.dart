import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../model/product_model.dart';

part 'cart_order_controller.freezed.dart';
part 'cart_order_controller.g.dart';

@freezed
abstract class CartFilter with _$CartFilter {
  const factory CartFilter({
    @Default('') String search,
    @Default(ProductCategoryModel.all) String categoryId,
  }) = _CartFilter;
}

@riverpod
class CartOrderController extends _$CartOrderController {
  @override
  CartFilter build() => CartFilter();

  void setSearch(String value) => state = state.copyWith(search: value);
  void clearSearch() => state = state.copyWith(search: '');

  void setCategory(String value) => state = state.copyWith(categoryId: value);
}
