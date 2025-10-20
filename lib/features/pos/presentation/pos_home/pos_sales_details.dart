import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../router/app_router.dart';
import '../../../../utils/extension/ext_date_time.dart';
import '../../../../utils/formatter.dart';
import '../../../../widgets/ui/pos_button.dart';
import '../../../cart/domain/cart_state.dart';
import '../../../cart/domain/cart_state_ext.dart';
import '../../../cart/provider/cart_provider.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cart.customer?.name ?? '',
                    style: textTheme.titleSmall?.copyWith(fontSize: 16, height: 1),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(
                        DateTime.parse(cart.createdAt).dateTimeId,
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cart.rc,
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'BELUM LUNAS',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentRed,
                    fontFamily: AppTheme.lato,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Rincian Pesanan',
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.primaryBlueDark,
            ),
            textAlign: TextAlign.left,
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
                        children: <Widget>[
                          Text(
                            'Pesanan ${batch.id}',
                            style: textTheme.titleSmall,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${Formatter.dateTime.format(DateTime.parse(batch.at))})',
                            style: textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            cart.items
                                .where((item) => item.batchId == batch.id)
                                .fold<double>(0, (prev, curr) => prev + curr.gross)
                                .toIdr,
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      for (final item in cart.items.toList().where((i) => i.batchId == batch.id)) ...<Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 32,
                              child: Text(
                                item.qty.toString(),
                                textAlign: TextAlign.right,
                                style: textTheme.bodySmall,
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 8,
                              child: Text(
                                "x",
                                style: textTheme.bodySmall,
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.product.name,
                                  style: textTheme.bodySmall,
                                ),
                                if (item.variant != null)
                                  Text(
                                    item.variant!.name,
                                    style: textTheme.bodySmall,
                                  ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              item.gross.toIdrNoSymbol,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
              PosButton(
                text: "Tambah Pesanan",
                icon: const Icon(Icons.add),
                variant: ButtonVariant.primaryOutlined,
                onPressed: () {
                  ref.read(cartProvider.notifier).createNewBatch(cart).then((_) {
                    if (!context.mounted) return;
                    context.goNamed(AppRouter.cart.name);
                  });
                },
              ),
              const SizedBox(width: 8),
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
      variant: ButtonVariant.secondaryOutlined,
      onPressed: () {
        // ref.read(printerStateProvider.notifier).print(TemplateReceipt(cart, outlet));
      },
    );
  }
}
