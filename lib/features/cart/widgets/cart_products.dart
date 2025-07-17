import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cart/cart_notifier.dart';
import '../../../data/product/product.model.dart';
import '../../../data/product/product_provider.dart';
import '../../../shared/utils/formatter.dart';
import '../manager/cart_selection_manager.dart';

class CartProducts extends ConsumerWidget {
  const CartProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartSelectionManagerProvider);
    var products = ref.watch(productDataProvider).products;

    if (state.categoryId != ProductCategory.kIdAll) {
      products = products.where((p) => p.categoryId == state.categoryId).toList();
    }

    if (state.search.isNotEmpty) {
      products = products.where((p) => p.name.toLowerCase().contains(state.search.toLowerCase())).toList();
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 19 / 8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _CartProductItem(product: product);
      },
    );
  }
}

class _CartProductItem extends ConsumerWidget {
  const _CartProductItem({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: Colors.grey),
      ),
      onPressed: () {
        ref.read(cartNotifierProvider.notifier).addProduct(product);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            Formatter.toIdr.format(product.price),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
