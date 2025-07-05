import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/core/config/app_palette.dart';
import 'package:ikki_pos_flutter/data/product/product_provider.dart';

class CategorySelection extends ConsumerWidget {
  const CategorySelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(productDataProvider).categories;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 48),
      child: ListView.separated(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final label = "${category.name} (${category.productCount})";

          return FilledButton.tonal(
            style: OutlinedButton.styleFrom(
              foregroundColor: Palette.primary,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Palette.primary, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            ),
            onPressed: () {},
            child: Text(label),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8);
        },
      ),
    );
  }
}
