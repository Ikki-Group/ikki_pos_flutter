import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cart/cart_model.dart';
import '../provider/pos_provider.dart';

class PosOrderListSection extends ConsumerStatefulWidget {
  const PosOrderListSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PosOrderListSectionState();
}

class _PosOrderListSectionState extends ConsumerState<PosOrderListSection> {
  @override
  Widget build(BuildContext context) {
    final carts = ref.watch(posCartListProvider);

    return carts.when(
      data: (carts) {
        if (carts.isEmpty) {
          return const Center(child: Text('No Orders'));
        }

        return ListView.builder(
          itemCount: carts.length,
          itemExtent: 160,
          itemBuilder: (context, index) {
            final cart = carts[index];
            return _PosOrderItem(cart);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _PosOrderItem extends ConsumerWidget {
  const _PosOrderItem(this.cart);

  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cart.rc),
                const Text('LUNAS'),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rizqy Nugroho'),
                Text('Rp. 10.000'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
