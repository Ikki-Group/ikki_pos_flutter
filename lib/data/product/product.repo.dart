import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'product.model.dart';

part 'product.repo.g.dart';

const jsonPath = 'assets/mock/product.json';

@Riverpod(keepAlive: true)
ProductRepo productRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final sp = ref.watch(sharedPrefsProvider);
  return ProductRepo(dio: dio, sp: sp);
}

class ProductRepo {
  ProductRepo({required this.dio, required this.sp});

  final Dio dio;
  final SharedPreferences sp;

  Future<ProductState> fetch() async {
    final res = await getMock();

    final sortedProducts = res.products.toList()..sort((a, b) => a.name.compareTo(b.name));
    final sortedCategories = res.categories.toList()..sort((a, b) => a.name.compareTo(b.name));

    final cc = <String, int>{
      ProductCategory.kIdAll: 0,
      ProductCategory.kIdFavorite: 0,
    };

    for (final product in res.products) {
      cc
        ..update(
          product.categoryId,
          (o) => o + 1,
          ifAbsent: () => 1,
        )
        ..update(
          ProductCategory.kIdAll,
          (o) => o + 1,
          ifAbsent: () => 1,
        );

      if (product.isFavorite) {
        cc.update(
          ProductCategory.kIdFavorite,
          (o) => o + 1,
        );
      }
    }

    final state = ProductState(
      products: sortedProducts,
      categories: [...ProductCategory.kCustomCategories, ...sortedCategories]
          .map(
            (category) => category.copyWith(
              productCount: cc[category.id] ?? 0,
            ),
          )
          .toList(),
    );

    await save(state);
    return state;
  }

  Future<ProductState> getLocal() async {
    final productsJson = sp.getString(SharedPrefsKeys.products.key);
    if (productsJson != null) {
      return ProductState.fromJson(jsonDecode(productsJson) as Json);
    } else {
      return fetch();
    }
  }

  Future<bool> save(ProductState products) async {
    return sp.setString(SharedPrefsKeys.products.key, jsonEncode(products));
  }

  Future<ProductState> getMock() async {
    final raw = await rootBundle.loadString(jsonPath);
    final decoded = json.decode(raw) as Json;

    final categories = (decoded['categories']! as List).map(
      (c) => ProductCategory.fromJson(c as Map<String, dynamic>),
    );

    final products = (decoded['products']! as List).map(
      (p) => ProductModel.fromJson(p as Map<String, dynamic>),
    );

    return ProductState(products: products.toList(), categories: categories.toList());
  }
}
