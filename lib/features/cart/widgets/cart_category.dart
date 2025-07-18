import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/product/product_provider.dart';
import '../manager/cart_selection_manager.dart';

const _kChipHeight = 45.0;

class CartCategory extends ConsumerWidget {
  const CartCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(productDataProvider.select((v) => v.categories));
    final selectedId = ref.watch(cartSelectionManagerProvider).categoryId;

    return SizedBox(
      height: _kChipHeight,
      child: ListView.separated(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final label = '${category.name} (${category.productCount})';
          final selected = category.id == selectedId;

          return ChoiceChip.elevated(
            side: const BorderSide(color: POSTheme.borderDark),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            label: SizedBox(
              height: _kChipHeight,
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            selected: selected,
            showCheckmark: false,
            onSelected: (bool value) {
              ref.read(cartSelectionManagerProvider.notifier).setCategory(category.id);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8);
        },
      ),
    );
  }
}
