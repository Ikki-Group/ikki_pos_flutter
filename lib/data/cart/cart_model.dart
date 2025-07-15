import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/data/sale/sale_model.dart';

part 'cart_model.freezed.dart';

@freezed
sealed class Cart with _$Cart {
  const factory Cart({
    @Default('') String id,
    @Default('') String rc,
    @Default(SaleMode(id: "", name: "")) SaleMode saleMode,
    @Default(0) int pax,
    @Default([]) List<CartItem> items,
    @Default('') String note,
    @Default(0) int gross,
    @Default(0) int discount,
    @Default(0) int net,
  }) = _Cart;
}

@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    @Default('') String id,
    @Default(0) int batch,
    @Default(CartItemProduct()) CartItemProduct product,
    CartItemVariant? variant,
    @Default(0) int qty,
    @Default(0) int price,
    @Default('') String note,
    @Default(0) int gross,
    @Default(0) int discount,
    @Default(0) int net,
  }) = _CartItem;
}

@freezed
sealed class CartItemProduct with _$CartItemProduct {
  const factory CartItemProduct({
    @Default('') String id,
    @Default('') String name,
    @Default(0) int price,
  }) = _CartItemProduct;
}

@freezed
sealed class CartItemVariant with _$CartItemVariant {
  const factory CartItemVariant({
    @Default('') String id,
    @Default('') String name,
    @Default(0) int price,
  }) = _CartItemVariant;
}
