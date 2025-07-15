import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,
    required String outletId,
    String? mokaId,
    required String name,
    required double price,
    required bool hasVariant,
    required String categoryId,
    @Default([]) List<ProductVariant> variants,
    @Default(false) bool isFavorite,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
sealed class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String name,
    required double price,
    String? mokaId,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => _$ProductVariantFromJson(json);
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

  factory ProductCategory.fromJson(Map<String, dynamic> json) => _$ProductCategoryFromJson(json);

  static const kIdAll = "all";
  static const kIdFavorite = "favorite";

  static const kCustomCategories = <ProductCategory>[
    ProductCategory(id: kIdAll, name: "All", productCount: 0, outletId: ''),
    ProductCategory(id: kIdFavorite, name: "Favorite", productCount: 0, outletId: ''),
  ];
}
