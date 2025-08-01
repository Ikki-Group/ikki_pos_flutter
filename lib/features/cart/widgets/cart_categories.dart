import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/product/product.model.dart';
import '../../../data/product/product.provider.dart';
import '../providers/cart_index_provider.dart';

class CartCategories extends ConsumerWidget {
  const CartCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(productProvider).requireValue.categories;
    final categoryId = ref.watch(cartIndexProvider).categoryId;

    void onPressed(ProductCategory category) {
      ref.read(cartIndexProvider.notifier).setCategory(category.id);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <_CategoryItem>[
          for (final category in categories)
            _CategoryItem(
              category: category,
              isSelected: categoryId == category.id,
              onPressed: () => onPressed(category),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  final ProductCategory category;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      constraints: const BoxConstraints(minWidth: 120),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          foregroundColor: isSelected ? POSTheme.textOnPrimary : POSTheme.textOnSecondary,
          backgroundColor: isSelected ? POSTheme.primaryBlue : POSTheme.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: POSTheme.borderLight),
          fixedSize: Size.infinite,
        ),
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Text(category.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              '${category.productCount} Items',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
