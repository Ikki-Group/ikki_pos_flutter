import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pos_home_notifier.freezed.dart';
part 'pos_home_notifier.g.dart';

@freezed
abstract class FilterState with _$FilterState {
  const factory FilterState({
    @Default(PosTabItem.all) PosTabItem tab,
    @Default('') String search,
    @Default(null) String? selectedCartId,
  }) = _FilterState;
}

enum PosTabItem {
  all('Semua'),
  cashier('Kasir'),
  table('Table');

  const PosTabItem(this.label);

  final String label;
}

@riverpod
class PosFilter extends _$PosFilter {
  @override
  FilterState build() => FilterState();

  void setTab(PosTabItem tab) => state = state.copyWith(tab: tab, selectedCartId: null);
  void setSearch(String search) => state = state.copyWith(search: search);
  void setSelectedCart(String cartId) => state = state.copyWith(selectedCartId: cartId);
}
