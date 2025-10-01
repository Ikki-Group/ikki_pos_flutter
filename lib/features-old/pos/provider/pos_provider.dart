import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cart/cart_model.dart';

part 'pos_provider.freezed.dart';
part 'pos_provider.g.dart';

@freezed
abstract class PosFilterState with _$PosFilterState {
  const factory PosFilterState({
    @Default(PosTabItem.all) PosTabItem tab,
    @Default('') String search,
    @Default(null) Cart? selectedCart,
  }) = _PosFilterState;
}

@riverpod
class PosFilter extends _$PosFilter {
  @override
  PosFilterState build() => const PosFilterState();

  void setSearch(String value) => state = state.copyWith(search: value);
  void setTab(PosTabItem value) => state = state.copyWith(tab: value, search: '', selectedCart: null);
  void setSelectedCart(Cart? cart) => state = state.copyWith(selectedCart: cart);
}

enum PosTabItem {
  all(label: 'Semua'),
  cashier(label: 'Kasir'),
  online(label: 'Online');

  const PosTabItem({required this.label});

  final String label;
}
