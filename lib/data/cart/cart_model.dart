import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/data/sale/sale_model.dart';

part 'cart_model.freezed.dart';

@freezed
sealed class Cart with _$Cart {
  const factory Cart({
    required String id,
    SaleMode? saleMode,
    @Default(0) int pax,
  }) = _Cart;
}
