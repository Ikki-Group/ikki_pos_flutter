import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/formatter.dart';

class ShiftPage extends ConsumerStatefulWidget {
  const ShiftPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShiftPageState();
}

class _ShiftPageState extends ConsumerState<ShiftPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            width: 300,
            child: _ActionsSection(),
          ),
          const SizedBox(width: 8),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    _SummarySection(),
                    SizedBox(height: 16),
                    _OutletInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsSection extends ConsumerWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 64),
              ),
              child: const Text('Tutup Toko'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummarySection extends ConsumerWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        Row(
          children: [
            _SummaryItem(
              'Total Transaksi',
              '10',
            ),
            SizedBox(width: 8),
            _SummaryItem(
              'Uang Tunai',
              'Rp. 100.000',
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _SummaryItem(
              'Produk Terjual',
              '10',
            ),
            SizedBox(width: 8),
            _SummaryItem(
              'Transaksi Void',
              '10',
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem(this.title, this.value);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black.withAlpha(120),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value, style: textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _OutletInfo extends StatelessWidget {
  const _OutletInfo();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final outletInfo = <KeyValue>[
      const KeyValue('Nama Toko', 'Ikki Coffee'),
      const KeyValue('Kas Awal', 'Rp. 100.000'),
      const KeyValue('Kasir', 'Rizqy Nugroho'),
      KeyValue('Waktu', Formatter.dateTime.format(DateTime.now())),
      const KeyValue('Alamat', 'Jl. Kebon Jeruk'),
      const KeyValue('No. Telepon', '08123456789'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text('Informasi Buka Toko', style: textTheme.labelLarge),
        ),
        const Divider(),
        const SizedBox(height: 8),
        ...outletInfo.map(
          (e) => ListTile(
            minTileHeight: 0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(e.key),
            subtitle: Text(e.value),
            dense: true,
          ),
        ),
      ],
    );
  }
}

class KeyValue {
  const KeyValue(this.key, this.value);

  final String key;
  final String value;
}
