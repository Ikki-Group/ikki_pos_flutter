import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../product/model/product_model.dart';
import '../../../product/provider/product_provider.dart';
import 'cart_order_controller.dart';

class CartCategories extends ConsumerWidget {
  const CartCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(productProvider.select((s) => s.categories));
    final categoryId = ref.watch(cartOrderControllerProvider.select((s) => s.categoryId));

    void onPressed(ProductCategoryModel category) {
      ref.read(cartOrderControllerProvider.notifier).setCategory(category.id);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final category in categories) ...[
            _CategoryItem(
              category: category,
              isSelected: categoryId == category.id,
              onPressed: () => onPressed(category),
            ),
            const SizedBox(width: 8),
          ],
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

  final ProductCategoryModel category;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Column(
        children: [
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${category.productCount} Items',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      showCheckmark: false,
    );
  }
}
