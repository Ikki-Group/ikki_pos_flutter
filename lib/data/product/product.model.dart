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
    required double price,
    required bool hasVariant,
    required String categoryId,
    String? mokaId,
    @Default([]) List<ProductVariant> variants,
    @Default(false) bool isFavorite,
  }) = _ProductModel;

  factory ProductModel.fromJson(Json json) => _$ProductModelFromJson(json);
}

@freezed
sealed class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String name,
    required double price,
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

  static const kCustomCategories = <ProductCategory>[
    ProductCategory(id: kIdAll, name: 'All', outletId: ''),
    ProductCategory(id: kIdFavorite, name: 'Favorite', outletId: ''),
  ];
}
