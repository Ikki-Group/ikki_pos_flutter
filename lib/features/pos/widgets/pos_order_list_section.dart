import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../shared/utils/formatter.dart';
import '../provider/pos_provider.dart';

class PosOrderListSection extends ConsumerWidget {
  const PosOrderListSection({
    required this.search,
    required this.selectedId,
    required this.selectedTab,
    required this.onSelected,
    super.key,
  });

  final String search;
  final String? selectedId;
  final PosTabItem selectedTab;
  final void Function(Cart) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carts = ref.watch(posCartListProvider);

    return carts.when(
      data: (carts) {
        carts = carts.where((c) => selectedTab == PosTabItem.process).toList().sortedBy((c) => c.createdAt);

        if (search.isNotEmpty) {
          carts = carts.where((e) => e.rc.contains(search)).toList();
        }

        if (carts.isEmpty) {
          return const Center(child: Text('No Orders'));
        }

        return ListView.builder(
          itemCount: carts.length,
          itemBuilder: (context, index) {
            final cart = carts[index];
            return _PosOrderItem(
              cart: cart,
              onPressed: () => onSelected(cart),
              isSelected: selectedId == cart.id,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _PosOrderItem extends ConsumerWidget {
  const _PosOrderItem({
    required this.cart,
    required this.onPressed,
    required this.isSelected,
  });

  final Cart cart;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final borderColor = isSelected ? POSTheme.primaryBlue : POSTheme.borderLight;

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? POSTheme.primaryBlue.withValues(alpha: .05) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cart.rc, style: textTheme.titleSmall),
                  Text('LUNAS', style: textTheme.titleSmall),
                ],
              ),
            ),
            Divider(color: borderColor),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Rizqy Nugroho', style: textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Formatter.toIdr.format(cart.net), style: textTheme.titleSmall),
                      Text('OPEN BILL', style: textTheme.titleSmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
