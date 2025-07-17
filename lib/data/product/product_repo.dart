import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'product.model.dart';

part 'product_repo.g.dart';

const jsonPath = 'assets/mock/product.json';

@riverpod
ProductRepo productRepo(ref) {
  return ProductRepo();
}

class ProductRepo {
  Future<List<ProductCategory>> getCategories() async {
    final response = await rootBundle.loadString(jsonPath);
    final decoded = json.decode(response);

    final categories = (decoded['categories'] as List).map(
      (c) => ProductCategory.fromJson(c as Map<String, dynamic>),
    );

    return [...ProductCategory.kCustomCategories, ...categories];
  }

  Future<List<Product>> getProducts() async {
    final response = await rootBundle.loadString(jsonPath);
    final decoded = json.decode(response);

    final products = (decoded['products'] as List).map(
      (p) => Product.fromJson(p as Map<String, dynamic>),
    );

    return products.toList();
  }
}
