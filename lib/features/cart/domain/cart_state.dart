import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../utils/json.dart';
import '../../sales/domain/model/sales_model.dart';

part 'cart_state.freezed.dart';
part 'cart_state.g.dart';

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default('') String id,
    @Default('') String rc,
    @Default(BillType.open) BillType billType,
    @Default(CartStatus.init) CartStatus status,
    @Default(SalesMode.dineIn) SalesMode salesMode,
    @Default(1) int pax,
    @Default('') String note,
    @Default(null) SalesCustomer? customer,
    @Default(SalesSource.cashier) SalesSource source,

    // Outlet info
    @Default('') String outletId,
    @Default('') String sessionId,

    // Cart control
    @Default(1) int batchId,
    @Default([]) List<SalesBatch> batches,
    @Default([]) List<CartItem> items,

    // Payments
    @Default([]) List<SalesPayment> payments,

    // Timestamp & actor
    @Default('') String createdAt,
    @Default('') String createdBy,
    @Default('') String updatedAt,
    @Default('') String updatedBy,
  }) = _CartState;

  factory CartState.fromJson(Json json) => _$CartStateFromJson(json);
}

@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required int batchId,
    required SalesMode salesMode,
    required SalesItemProduct product,
    required SalesItemVariant? variant,
    @Default('') String note,
    @Default(1) int qty,
  }) = _CartItem;

  factory CartItem.fromJson(Json json) => _$CartItemFromJson(json);
}

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

// extension CartPaymentX on CartPayment {
//   bool get isCash => type == PaymentType.cash;
// }
