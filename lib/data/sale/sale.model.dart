import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale.model.freezed.dart';
part 'sale.model.g.dart';

@freezed
sealed class SaleMode with _$SaleMode {
  const factory SaleMode({
    required String id,
    required String name,
  }) = _SaleMode;

  factory SaleMode.fromJson(Map<String, dynamic> json) => _$SaleModeFromJson(json);

  static const List<SaleMode> values = [
    SaleMode(id: '1', name: 'Dine-in'),
    SaleMode(id: '2', name: 'Take Away'),
  ];
}
