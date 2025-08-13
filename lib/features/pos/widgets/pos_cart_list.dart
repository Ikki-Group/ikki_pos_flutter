import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cart/cart_provider.dart';
import '../provider/pos_provider.dart';
import 'pos_cart_list_item.dart';

class PosCartList extends ConsumerWidget {
  const PosCartList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(posFilterProvider);
    var items = ref.watch(cartDataProvider);
    items = items.toList().reversed.toList();

    if (filter.tab == PosTabItem.online) items = [];
    if (filter.search.isNotEmpty) {
      items = items.where((item) {
        final key = '${item.rc} ${item.customer?.name} ${item.customer?.email} ${item.note}';
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
                child: Text('Daftar Pesanan', style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: switch (items) {
                _ when items.isEmpty => const Center(child: Text('Tidak ada pesanan')),
                _ => ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return PosCartListItem(
                      cart: item,
                      onTap: () => ref.read(posFilterProvider.notifier).setSelectedCart(item),
                      isSelected: item.id == filter.selectedCart?.id,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
