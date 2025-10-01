import 'package:freezed_annotation/freezed_annotation.dart';

import '../json.dart';

part 'product.model.freezed.dart';
part 'product.model.g.dart';

@freezed
sealed class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String outletId,
    required String name,
    required String desc,
    required double price,
    required bool pricingBySalesMode,
    required bool hasVariant,
    required List<ProductVariant> variants,
    required bool isActive,
    required String createdAt,
    required String updatedAt,
    required String createdBy,
    required String updatedBy,
    @Default(null) String? categoryId,
    String? mokaId,
    @Default(false) bool isFavorite,
  }) = _ProductModel;

  factory ProductModel.fromJson(Json json) => _$ProductModelFromJson(json);
}

@freezed
abstract class PricingModel with _$PricingModel {
  const factory PricingModel({
    required String mode,
    required double price,
  }) = _PricingModel;

  factory PricingModel.fromJson(Json json) => _$PricingModelFromJson(json);
}

@freezed
sealed class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String name,
    required bool isDefault,
    required double price,
    required List<PricingModel> prices,
    String? mokaId,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Json json) => _$ProductVariantFromJson(json);
}

@freezed
sealed class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required String id,
    required String outletId,
    required String name,
    String? mokaId,
    String? desc,
    @Default(0) int productCount,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Json json) => _$ProductCategoryFromJson(json);

  static const kIdAll = 'all';
  static const kIdFavorite = 'favorite';

  static const List<ProductCategory> kCustomCategories = <ProductCategory>[
    ProductCategory(id: kIdAll, name: 'All', outletId: ''),
    ProductCategory(id: kIdFavorite, name: 'Favorite', outletId: ''),
  ];
}

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default([]) List<ProductModel> products,
    @Default([]) List<ProductCategory> categories,
  }) = _ProductState;

  factory ProductState.fromJson(Map<String, dynamic> json) => _$ProductStateFromJson(json);
}
