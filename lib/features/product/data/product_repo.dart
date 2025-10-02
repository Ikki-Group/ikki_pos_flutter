import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/shared_prefs.dart';
import '../../../model/product_model.dart';
import 'product_state.dart';

part 'product_repo.g.dart';

@Riverpod(keepAlive: true)
ProductRepo productRepo(Ref ref) {
  final sp = ref.watch(sharedPrefsProvider);
  return ProductRepoImpl(sp: sp);
}

abstract class ProductRepo {
  Future<ProductState> getState();
  Future<bool> saveState(ProductState state);

  Future<bool> syncState(List<ProductModel> products, List<ProductCategoryModel> categories);
}

class ProductRepoImpl implements ProductRepo {
  ProductRepoImpl({required this.sp});

  final SharedPreferences sp;

  @override
  Future<ProductState> getState() async {
    final raw = sp.getString(SharedPrefsKeys.products.key);
    if (raw == null) {
      throw Exception('Products not found, ensure to initialize');
    }
    final state = ProductState.fromJson(jsonDecode(raw));
    return Future.value(state);
  }

  @override
  Future<bool> saveState(ProductState state) {
    final encoded = jsonEncode(state);
    return sp.setString(SharedPrefsKeys.products.key, encoded);
  }

  @override
  Future<bool> syncState(List<ProductModel> products, List<ProductCategoryModel> categories) {
    categories = [
      ProductCategoryModel(
        id: ProductCategoryModel.all,
        name: "Semua",
      ),
      ProductCategoryModel(
        id: ProductCategoryModel.favorite,
        name: "Favorit",
      ),
      ...categories,
      ProductCategoryModel(
        id: ProductCategoryModel.unknown,
        name: "Tanpa Kategori",
      ),
    ];

    // calculate product count
    categories = categories.map((category) {
      switch (category.id) {
        case ProductCategoryModel.all:
          category = category.copyWith(productCount: products.length);
          break;
        case ProductCategoryModel.favorite:
          // category = category.copyWith(productCount: products.where((p) => p.isActive).length);
          break;
        case ProductCategoryModel.unknown:
          category = category.copyWith(productCount: products.where((p) => p.categoryId == null).length);
          break;
        default:
          category = category.copyWith(productCount: products.where((p) => p.categoryId == category.id).length);
          break;
      }

      return category;
    }).toList();

    final state = ProductState(products: products, categories: categories);
    return saveState(state);
  }
}
