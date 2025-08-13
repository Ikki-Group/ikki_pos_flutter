import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../shared/utils/formatter.dart';
import '../../../widgets/ui/pos_button.dart';
import '../provider/pos_provider.dart';

class PosCartDetails extends ConsumerWidget {
  const PosCartDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(posFilterProvider.select((value) => value.selectedCart));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: POSTheme.borderMedium),
          ),
          child: cart == null ? const _EmptyState() : _CartDetails(cart),
        ),
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.receipt_long_rounded, size: 48, color: POSTheme.primaryBlueLight),
        const SizedBox(height: 8),
        Text(
          'Pilih item untuk melihat rincian',
          style: textTheme.titleSmall?.copyWith(color: POSTheme.primaryBlueLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CartDetails extends StatelessWidget {
  const _CartDetails(this.cart);
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rizqy Nugroho', style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        Formatter.dateTime.format(DateTime.parse(cart.createdAt)),
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cart.rc,
                        style: textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'LUNAS',
                  style: textTheme.titleMedium?.copyWith(color: POSTheme.statusSuccess),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rincian Pesanan',
                  style: textTheme.labelLarge,
                  textAlign: TextAlign.left,
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Pesanan'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final batch in cart.batches) ...[
                      Row(
                        children: [
                          Text('Pesanan ${batch.id}', style: textTheme.titleSmall),
                          const SizedBox(width: 8),
                          Text(
                            Formatter.dateTime.format(DateTime.parse(batch.at)),
                            style: textTheme.bodySmall,
                          ),
                          const Spacer(),
                          Text('Rp 100.000', style: textTheme.titleSmall),
                        ],
                      ),
                      for (final item in cart.items.toList().where((i) => i.batchId == batch.id)) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                          child: Row(
                            children: [
                              Expanded(child: Text(item.product.name, style: textTheme.bodySmall)),
                              Text('Rp 100.000', style: textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              PosButton(
                text: 'Void',
                onPressed: () {},
                variant: ButtonVariant.destructiveOutlined,
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                label: const Text('Cetak'),
                icon: const Icon(Icons.print),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text('Bayar'),
                icon: const Icon(Icons.payments_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
