import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_provider.dart';
import '../../../shared/utils/formatter.dart';
import '../provider/pos_provider.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  final searchController = TextEditingController();
  PosTabItem selectedTab = PosTabItem.process;
  Cart? selectedCart;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onTapCart(Cart cart) {
    selectedCart = cart;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: POSTheme.backgroundSecondary,
      child: Column(
        children: [
          const _HeaderSection(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _CartListSection(onTap: onTapCart),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 8,
                    child: _CartDetailsSections(
                      cart: selectedCart,
                    ),
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        spacing: 8,
        children: [
          FilterChip(label: const Text('Semua (10)'), onSelected: (_) {}, selected: true, showCheckmark: false),
          FilterChip(label: const Text('Kasir (1)'), onSelected: (_) {}),
          FilterChip(label: const Text('Order Online (3)'), onSelected: (_) {}),
          const Spacer(),
          const Flexible(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Order...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartListSection extends ConsumerWidget {
  const _CartListSection({required this.onTap});

  final void Function(Cart cart) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    var items = ref.watch(cartDataProvider);
    items = items.toList().reversed.toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return InkWell(
            onTap: () => onTap(item),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: POSTheme.borderLight),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Formatter.dateTime.format(DateTime.parse(item.createdAt)), style: textTheme.titleSmall),
                        Text(item.rc, style: textTheme.titleSmall?.copyWith(fontSize: 14)),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rizqy Nugroho', style: textTheme.titleSmall),
                            Text(Formatter.toIdr.format(item.net), style: textTheme.titleSmall),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('-', style: textTheme.titleSmall),
                            Text('Belum Lunas', style: textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CartDetailsSections extends StatelessWidget {
  const _CartDetailsSections({required this.cart});

  final Cart? cart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
                    const Icon(Icons.receipt_long_rounded, size: 48, color: POSTheme.primaryBlueDark),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih item untuk melihat details',
                      style: textTheme.titleMedium?.copyWith(color: POSTheme.primaryBlueDark),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cart!.rc, style: textTheme.titleSmall),
                              const SizedBox(height: 8),
                              Text(
                                Formatter.dateTime.format(DateTime.parse(cart!.createdAt)),
                                style: textTheme.titleSmall,
                              ),
                            ],
                          ),
                          Text('LUNAS', style: textTheme.titleSmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rincian Pesanan', style: textTheme.titleSmall, textAlign: TextAlign.left),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Pesanan'),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                for (final batch in cart!.batches) ...[
                                  Row(
                                    children: [
                                      Text('Pesanan ${batch.id}', style: textTheme.titleSmall),
                                      const SizedBox(width: 8),
                                      Text(
                                        Formatter.dateTime.format(DateTime.parse(batch.at)),
                                        style: textTheme.bodyMedium,
                                      ),
                                      const Spacer(),
                                      Text('Rp 100.000', style: textTheme.titleSmall),
                                    ],
                                  ),
                                  for (final item in cart!.items.toList().where((i) => i.batchId == batch.id)) ...[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(item.product.name, style: textTheme.bodyMedium)),
                                          const Text('Rp 100.000'),
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
                          OutlinedButton(onPressed: () {}, child: const Text('Void')),
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
                ),
        ),
      ),
    );
  }
}
