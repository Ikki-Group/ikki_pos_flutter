import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_provider.dart';
import '../../../shared/utils/formatter.dart';
import '../../../widgets/ui/pos_button.dart';
import '../provider/pos_provider.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: POSTheme.backgroundSecondary,
      child: Column(
        children: [
          _HeaderSection(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _CartListSection(),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 8,
                    child: _CartDetailsSections(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends ConsumerStatefulWidget {
  const _HeaderSection();

  @override
  ConsumerState<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<_HeaderSection> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()
      ..addListener(() {
        ref.read(posFilterProvider.notifier).setSearch(controller.text);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(posFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          for (final tab in PosTabItem.values) ...[
            FilterChip(
              label: Text(tab.label),
              onSelected: (_) => {
                ref.read(posFilterProvider.notifier).setTab(tab),
              },
              showCheckmark: false,
              selected: tab == filter.tab,
            ),
          ],
          const Spacer(),
          Expanded(
            child: TextField(
              autocorrect: false,
              enableSuggestions: false,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Cari Order...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filter.search.isNotEmpty
                    ? InkWell(
                        onTap: controller.clear,
                        child: const Icon(Icons.highlight_off),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartListSection extends ConsumerWidget {
  const _CartListSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(posFilterProvider);
    var items = ref.watch(cartDataProvider);
    items = items.toList().reversed.toList();

    if (filter.tab == PosTabItem.online) items = [];
    if (filter.search.isNotEmpty) {
      items = items.where((e) => e.rc.contains(filter.search)).toList();
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
              child: ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _CartListItem(
                    cart: item,
                    onTap: (cart) => ref.read(posFilterProvider.notifier).setSelectedCart(cart),
                    isSelected: item.id == filter.selectedCart?.id,
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartListItem extends StatelessWidget {
  const _CartListItem({required this.cart, required this.onTap, required this.isSelected});

  final bool isSelected;
  final Cart cart;
  final void Function(Cart cart) onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderColor = isSelected ? POSTheme.primaryBlue.withValues(alpha: .5) : POSTheme.borderLight;
    final backgroundColor = isSelected ? POSTheme.primaryBlueLight.withValues(alpha: .05) : Colors.white;

    return InkWell(
      onTap: () => onTap(cart),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatter.dateTime.format(DateTime.parse(cart.createdAt)),
                    style: textTheme.labelMedium,
                  ),
                  Text(
                    cart.rc,
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Divider(color: borderColor),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rizqy Nugroho', style: textTheme.labelMedium),
                      Text(Formatter.toIdr.format(cart.net), style: textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('-', style: textTheme.labelMedium),
                      Text('Belum Lunas', style: textTheme.labelMedium?.copyWith(color: POSTheme.accentRed)),
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

class _CartDetailsSections extends ConsumerWidget {
  const _CartDetailsSections();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
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
          child: cart == null
              ? Column(
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
                )
              : _CartDetailsView(cart),
        ),
      ),
    );
  }
}

class _CartDetailsView extends StatelessWidget {
  const _CartDetailsView(this.cart);

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
