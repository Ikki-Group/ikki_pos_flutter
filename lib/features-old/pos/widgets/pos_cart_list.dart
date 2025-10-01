import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../data/cart/cart_enum.dart';
import '../../../data/cart/cart_provider.dart';
import '../provider/pos_provider.dart';
import 'pos_cart_list_item.dart';

class PosCartList extends ConsumerWidget {
  const PosCartList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final filter = ref.watch(posFilterProvider);

    var items = ref.watch(cartDataProvider);
    items = items.filter((item) => item.status != CartStatus.success).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (filter.tab == PosTabItem.online) items = [];
    if (filter.search.isNotEmpty) {
      items = items.where((item) {
        final key = '${item.rc} ${item.customer?.name} ${item.customer?.email} ${item.note}';
        if (item.status == CartStatus.success) return false;
        return key.contains(filter.search);
      }).toList();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Daftar Pesanan', style: textTheme.labelLarge),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Tidak ada pesanan'))
                  : ListView.separated(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return PosCartListItem(
                          cart: item,
                          onTap: () => ref.read(posFilterProvider.notifier).setSelectedCart(item),
                          isSelected: item.id == filter.selectedCart?.id,
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
