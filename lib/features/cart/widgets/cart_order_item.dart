import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_notifier.dart';

class CartOrderList extends ConsumerWidget {
  const CartOrderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartNotifierProvider.select((s) => s.items));
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) {
        return _CartOrderItem(
          item: items[index],
        );
      },
    );
  }
}

class _CartOrderItem extends ConsumerWidget {
  const _CartOrderItem({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Center(child: Text('${item.qty}')),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (item.variant != null)
                Text(
                  item.variant!.name,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (item.note.isNotEmpty)
                Text(
                  item.note,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.clear)),
      ],
    );
  }
}
