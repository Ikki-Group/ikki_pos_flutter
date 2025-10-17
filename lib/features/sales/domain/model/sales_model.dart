import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../utils/json.dart';

part 'sales_model.freezed.dart';
part 'sales_model.g.dart';

@freezed
sealed class SalesModel with _$SalesModel {
  const factory SalesModel({
    required String id,
    required String rc,
    required BillType billType,
    required SalesMode salesMode,
    required int pax,
    required String note,
    required SalesCustomer? customer,
    required SalesSource source,

    // Outlet & Shift info
    required String outletId,
    required String sessionId,

    // Order items & batches
    required List<SalesBatch> batches,
    required List<SalesItem> items,

    // Pricing
    required double total,
    required double discount,
    required double net,

    // Payments
    required List<SalesPayment> payments,

    // Timestamp & actor
    required String createdAt,
    required String createdBy,
    required String updatedAt,
    required String updatedBy,
  }) = _SalesModel;

  factory SalesModel.fromJson(Json json) => _$SalesModelFromJson(json);
}

@freezed
sealed class SalesCustomer with _$SalesCustomer {
  const factory SalesCustomer({
    required String name,
    String? id,
    String? email,
    String? phone,
  }) = _SalesCustomer;

  factory SalesCustomer.fromJson(Json json) => _$SalesCustomerFromJson(json);
}

@freezed
sealed class SalesBatch with _$SalesBatch {
  const factory SalesBatch({
    required int id,
    required String at,
    required String by,
  }) = _SalesBatch;

  factory SalesBatch.fromJson(Json json) => _$SalesBatchFromJson(json);
}

@freezed
sealed class SalesItem with _$SalesItem {
  const factory SalesItem({
    required String id,
    required String batchId,
    required SalesMode salesMode,
    required SalesItemProduct product,
    required SalesItemVariant? variant,
    required String note,
    required int qty,

    /// Price of each item
    required double price,
    required double gross,
    required double discount,
    required double net,
  }) = _SalesItem;

  factory SalesItem.fromJson(Json json) => _$SalesItemFromJson(json);
}

@freezed
sealed class SalesItemProduct with _$SalesItemProduct {
  const factory SalesItemProduct({
    required String id,
    required String name,
    required double price,
  }) = _SalesItemProduct;

  factory SalesItemProduct.fromJson(Json json) => _$SalesItemProductFromJson(json);
}

@freezed
sealed class SalesItemVariant with _$SalesItemVariant {
  const factory SalesItemVariant({
    required String id,
    required String name,
    required double price,
  }) = _SalesItemVariant;

  factory SalesItemVariant.fromJson(Json json) => _$SalesItemVariantFromJson(json);
}

@freezed
sealed class SalesPayment with _$SalesPayment {
  const factory SalesPayment({
    required String id,
    required String label,
    required double amount,
    required PaymentType type,
    required String at,
    required String by,
    double? change,
    double? tender,
  }) = _SalesPayment;

  factory SalesPayment.fromJson(Json json) => _$SalesPaymentFromJson(json);
}
