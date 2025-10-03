import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/formatter.dart';
import 'shift_notifier.dart';

class ShiftSummary extends ConsumerWidget {
  const ShiftSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref
        .watch(shiftSummaryDataProvider)
        .map<ShiftSummaryData?>(
          data: (data) => data.value,
          error: (_) => null,
          loading: (_) => null,
        );

    return Column(
      children: [
        Row(
          children: [
            _Item(
              'Total Transaksi',
              data?.transactionCount.toString() ?? '0',
            ),
            const SizedBox(width: 8),
            _Item(
              'Uang Tunai',
              data?.cashBalance.toIdr ?? '0',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _Item(
              'Produk Terjual',
              data?.productSales.toString() ?? '0',
            ),
            const SizedBox(width: 8),
            _Item(
              'Transaksi Void',
              data?.transacionVoid.toString() ?? '0',
            ),
          ],
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this.title, this.value);

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
