import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/json.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String outletId,
    required String mokaId,
    required String name,
    required String desc,
    required bool pricingBySalesMode,
    required bool hasVariant,
    required List<ProductVariantModel> variants,
    required double price,
    required String? categoryId,
    required bool isActive,
    required String createdAt,
    required String createdBy,
    required String updatedAt,
    required String updatedBy,
  }) = _ProductModel;

  factory ProductModel.fromJson(Json json) => _$ProductModelFromJson(json);
}

@freezed
abstract class ProductVariantModel with _$ProductVariantModel {
  const factory ProductVariantModel({
    required String id,
    required String name,
    required bool isDefault,
    required double price,
    required List<ProductPriceModel> prices,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Json json) => _$ProductVariantModelFromJson(json);
}

@freezed
abstract class ProductPriceModel with _$ProductPriceModel {
  const factory ProductPriceModel({
    required String id,
    required double price,
  }) = _ProductPriceModel;

  factory ProductPriceModel.fromJson(Json json) => _$ProductPriceModelFromJson(json);
}

@freezed
abstract class ProductCategoryModel with _$ProductCategoryModel {
  const factory ProductCategoryModel({
    required String id,
    required String name,
    String? desc,
    String? createdAt,
    String? createdBy,
    String? updatedAt,
    String? updatedBy,
    @Default(0) int productCount,
  }) = _ProductCategoryModel;

  factory ProductCategoryModel.fromJson(Json json) => _$ProductCategoryModelFromJson(json);

  static const String all = "ALL";
  static const String favorite = "FAVORITE";
  static const String unknown = "UNKNOWN";

  static List<ProductCategoryModel> defaultCategories() {
    return [
      ProductCategoryModel(
        id: all,
        name: "Semua",
      ),
      ProductCategoryModel(
        id: favorite,
        name: "Favorit",
      ),
      ProductCategoryModel(
        id: unknown,
        name: "Tanpa Kategori",
      ),
    ];
  }
}
