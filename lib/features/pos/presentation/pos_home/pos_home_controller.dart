import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pos_home_controller.freezed.dart';
part 'pos_home_controller.g.dart';

@freezed
abstract class FilterState with _$FilterState {
  const factory FilterState({
    @Default(PosTabItem.all) PosTabItem tab,
    @Default('') String search,
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

  void setTab(PosTabItem tab) => state = state.copyWith(tab: tab);
  void setSearch(String search) => state = state.copyWith(search: search);
}
