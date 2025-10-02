// import 'package:freezed_annotation/freezed_annotation.dart';

// import '../../features-old/payment/payment_enum.dart';
// import '../json.dart';
// import '../sale/sale_enum.dart';
// import 'cart_enum.dart';

// part 'cart_model.freezed.dart';
// part 'cart_model.g.dart';

// @freezed
// sealed class Cart with _$Cart {
//   const factory Cart({
//     @Default('') String id,
//     @Default('') String rc,
//     @Default(BillType.open) BillType billType,
//     @Default(CartStatus.process) CartStatus status,
//     @Default(SaleMode.dineIn) SaleMode saleMode,
//     @Default(1) int pax,
//     @Default('') String note,
//     @Default(null) CartCustomer? customer,
//     @Default(CartSource.cashier) CartSource source,

//     // Outlet info
//     @Default('') String outletId,
//     @Default('') String sessionId,

//     // Cart control
//     @Default(1) int batchId,
//     @Default([]) List<CartBatch> batches,
//     @Default([]) List<CartItem> items,

//     // Calculated value
//     @Default(0) double gross,
//     @Default(0) double discount,
//     @Default(0) double net,

//     // Payments
//     @Default([]) List<CartPayment> payments,

//     // Change log
//     @Default([]) List<String> logs,

//     // Timestamp & actor
//     @Default('') String createdAt,
//     @Default('') String createdBy,
//     @Default('') String updatedAt,
//     @Default('') String updatedBy,
//   }) = _Cart;

//   factory Cart.fromJson(Json json) => _$CartFromJson(json);
// }

// @freezed
// sealed class CartItem with _$CartItem {
//   const factory CartItem({
//     @Default('') String id,
//     @Default(0) int batchId,
//     @Default(CartItemProduct()) CartItemProduct product,
//     @Default(null) CartItemVariant? variant,
//     @Default('') String note,
//     @Default(0) int qty,
//     @Default(0) double price,
//     @Default(0) double gross,
//     @Default(0) double discount,
//     @Default(0) double net,
//   }) = _CartItem;

//   factory CartItem.fromJson(Json json) => _$CartItemFromJson(json);
// }

// @freezed
// sealed class CartItemProduct with _$CartItemProduct {
//   const factory CartItemProduct({
//     @Default('') String id,
//     @Default('') String name,
//     @Default(0) double price,
//   }) = _CartItemProduct;

//   factory CartItemProduct.fromJson(Json json) => _$CartItemProductFromJson(json);
// }

// @freezed
// sealed class CartItemVariant with _$CartItemVariant {
//   const factory CartItemVariant({
//     @Default('') String id,
//     @Default('') String name,
//     @Default(0) double price,
//   }) = _CartItemVariant;

//   factory CartItemVariant.fromJson(Json json) => _$CartItemVariantFromJson(json);
// }

// @freezed
// sealed class CartBatch with _$CartBatch {
//   const factory CartBatch({
//     @Default(0) int id,
//     @Default('') String at,
//     @Default('') String by,
//   }) = _CartBatch;

//   factory CartBatch.fromJson(Json json) => _$CartBatchFromJson(json);
// }

// @freezed
// sealed class CartPayment with _$CartPayment {
//   const factory CartPayment({
//     required String id,
//     required double amount,
//     required String label,
//     required PaymentType type,
//     required String at,
//     required String by,
//     @Default(false) bool isDraft,
//     double? change,
//     double? tender,
//   }) = _CartPayment;

//   factory CartPayment.fromJson(Json json) => _$CartPaymentFromJson(json);
// }

// @freezed
// sealed class CartCustomer with _$CartCustomer {
//   const factory CartCustomer({
//     required String name,
//     String? id,
//     String? email,
//     String? phone,
//   }) = _CartCustomer;

//   factory CartCustomer.fromJson(Json json) => _$CartCustomerFromJson(json);
// }
