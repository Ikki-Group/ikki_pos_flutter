import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/formatter.dart';
import '../../../../widgets/ui/pos_button.dart';
import '../../../cart/model/cart_extension.dart';
import '../../../cart/model/cart_state.dart';
import '../../../sales/provider/sales_provider.dart';
import 'pos_home_notifier.dart';

class PosSalesDetails extends ConsumerWidget {
  const PosSalesDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCartId = ref.watch(posFilterProvider.select((value) => value.selectedCartId));
    final salesState = ref.watch(salesProvider);

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
            border: Border.all(color: AppTheme.borderMedium),
          ),
          child: salesState.when<Widget>(
            data: (data) {
              final cart = data.firstWhereOrNull((e) => e.id == selectedCartId);
              if (cart == null) return const _EmptyState();
              return _CartDetails(cart);
            },
            error: (_, _) => const _EmptyState(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
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
      children: <Widget>[
        const Icon(Icons.receipt_long_rounded, size: 48, color: AppTheme.primaryBlueLight),
        const SizedBox(height: 8),
        Text(
          'Pilih item untuk melihat rincian',
          style: textTheme.titleSmall?.copyWith(color: AppTheme.primaryBlueLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CartDetails extends ConsumerWidget {
  const _CartDetails(this.cart);
  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(cart.label, style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
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
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'BELUM LUNAS',
                  style: textTheme.titleMedium?.copyWith(color: AppTheme.accentRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Rincian Pesanan',
                style: textTheme.labelLarge,
                textAlign: TextAlign.left,
              ),
              OutlinedButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: AppTheme.borderLight),
                ),
                onPressed: () {
                  // final user = ref.read(userProvider).selectedUser;
                  // ref.read(cartStateProvider.notifier).newBatch(cart, user);
                  // context.goNamed(IkkiRouter.cart.name);
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Pesanan'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    for (final batch in cart.batches) ...<Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Pesanan ${batch.id}',
                            style: textTheme.labelMedium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${Formatter.dateTime.format(DateTime.parse(batch.at))})',
                            style: textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            cart.items
                                .where((item) => item.batchId == batch.id)
                                .fold<double>(0, (prev, curr) => prev + curr.gross)
                                .toIdr,
                            style: textTheme.labelMedium,
                          ),
                        ],
                      ),
                      for (final item in cart.items.toList().where((i) => i.batchId == batch.id)) ...[
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.qty} x ${item.product.name}',
                                  style: textTheme.bodySmall,
                                ),
                              ),
                              Text(item.gross.toIdrNoSymbol, style: textTheme.bodySmall),
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
            children: <Widget>[
              PosButton(
                text: 'Void',
                onPressed: () {},
                variant: ButtonVariant.destructiveOutlined,
              ),
              const Spacer(),
              _PrintButton(cart),
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

class _PrintButton extends ConsumerWidget {
  const _PrintButton(this.cart);

  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final outlet = ref.watch(outletProvider);
    return PosButton(
      text: 'Cetak',
      icon: const Icon(Icons.print),
      onPressed: () {
        // ref.read(printerStateProvider.notifier).print(TemplateReceipt(cart, outlet));
      },
    );
  }
}
