import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/product/product.model.dart';

part 'cart_index_provider.freezed.dart';
part 'cart_index_provider.g.dart';

@freezed
abstract class CartIndexState with _$CartIndexState {
  const factory CartIndexState({
    required String search,
    required String categoryId,
  }) = _CartIndexState;
}

@riverpod
class CartIndex extends _$CartIndex {
  @override
  CartIndexState build() => const CartIndexState(search: '', categoryId: ProductCategory.kIdAll);

  void setSearch(String value) => state = state.copyWith(search: value);
  void clearSearch() => state = state.copyWith(search: '');

  void setCategory(String value) => state = state.copyWith(categoryId: value);
}
