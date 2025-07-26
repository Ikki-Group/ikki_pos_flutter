import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pos_theme.dart';
import '../../../data/cart/cart_state.dart';
import '../../../data/product/product.model.dart';
import '../../../data/product/product.provider.dart';
import '../../../shared/utils/formatter.dart';
import '../providers/cart_index_provider.dart';
import 'cart_product_picker_dialog.dart';

class CartProducts extends ConsumerWidget {
  const CartProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var products = ref.watch(productProvider.select((s) => s.requireValue.products));
    final state = ref.watch(cartIndexProvider);

    if (state.categoryId != ProductCategory.kIdAll) {
      products = products.where((product) => product.categoryId == state.categoryId).toList();
    }

    if (state.search.isNotEmpty) {
      products = products.where((product) => product.name.toLowerCase().contains(state.search.toLowerCase())).toList();
    }

    final noRecord = products.isEmpty;

    void onPress(ProductModel product) {
      if (product.hasVariant) {
        CartProductPickerDialog.show(
          context,
          product: product,
        );
      } else {
        ref.read(cartStateProvider.notifier).addProductDirectly(product);
      }
    }

    return Expanded(
      child: noRecord
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart, size: 64, color: POSTheme.neutral500),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada produk yang ditemukan',
                    style: context.textTheme.headlineSmall,
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 19 / 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductItem(
                  product: product,
                  onPress: () => onPress(product),
                );
              },
            ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({required this.product, required this.onPress});

  final ProductModel product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: POSTheme.neutral800,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        side: const BorderSide(color: POSTheme.neutral200),
      ),
      onPressed: onPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${product.hasVariant ? '🧩' : ''} ${product.name}",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            Formatter.toIdr.format(product.price),
            style: const TextStyle(fontSize: 14, color: POSTheme.neutral600),
          ),
        ],
      ),
    );
  }
}
