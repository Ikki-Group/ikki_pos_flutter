import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/product/product.model.dart';

part 'cart_selection_manager.freezed.dart';
part 'cart_selection_manager.g.dart';

@freezed
sealed class CartSelectionManagerState with _$CartSelectionManagerState {
  const factory CartSelectionManagerState({
    required String search,
    required String categoryId,
  }) = _CartSelectionManagerState;
  const CartSelectionManagerState._();
}

@riverpod
class CartSelectionManager extends _$CartSelectionManager {
  @override
  CartSelectionManagerState build() {
    return const CartSelectionManagerState(
      search: '',
      categoryId: ProductCategory.kIdAll,
    );
  }

  void setSearch(String value) => state = state.copyWith(search: value);
  void clearSearch() => state = state.copyWith(search: '');
  void setCategory(String value) => state = state.copyWith(categoryId: value);
}
