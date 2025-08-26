import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/formatter.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Summary(),
        _TableTransactions(),
      ],
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 1,
              shadowColor: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Total Transaksi', style: textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text('1 Transaksi', style: textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              elevation: 1,
              shadowColor: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Total Pembelian', style: textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Text(10000.0.toIdr, style: textTheme.titleMedium),
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

class _TableTransactions extends ConsumerWidget {
  const _TableTransactions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          columns: const [
            DataColumn2(
              label: Text('Column '),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Column B'),
            ),
            DataColumn(
              label: Text('Column C'),
            ),
            DataColumn(
              label: Text('Column D'),
            ),
            DataColumn(
              label: Text('Column NUMBERS'),
              numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
            100,
            (index) => DataRow(
              cells: [
                DataCell(Text('A' * (10 - index % 10))),
                DataCell(Text('B' * (10 - (index + 5) % 10))),
                DataCell(Text('C' * (15 - (index + 5) % 10))),
                DataCell(Text('D' * (15 - (index + 10) % 10))),
                DataCell(Text(((index + 0.1) * 25.4).toString())),
              ],
            ),
          ),
        ),
      ),
    );

    //   return Expanded(
    //     child: Padding(
    //       padding: const EdgeInsets.all(14),
    //       child: Column(
    //         children: [
    //           Table(
    //             columnWidths: templateColumnWidths,
    //             children: [
    //               TableRow(
    //                 children: [
    //                   Text('No Transaksi', style: textTheme.bodyLarge),
    //                   Text('Waktu', style: textTheme.bodyLarge),
    //                   Text('Nama', style: textTheme.bodyLarge),
    //                   Text('Kasir', style: textTheme.bodyLarge),
    //                   Text('Info', style: textTheme.bodyLarge),
    //                   Text('Total', style: textTheme.bodyLarge),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           Expanded(
    //             child: SingleChildScrollView(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(14),
    //                 child: Table(
    //                   columnWidths: templateColumnWidths,
    //                   children: [
    //                     ...List.generate(100, (index) {
    //                       return TableRow(
    //                         children: [
    //                           Text('${index + 1}', style: textTheme.bodyLarge),
    //                           Text('2022/01/01', style: textTheme.bodyLarge),
    //                           Text('Rizqy Nugroho', style: textTheme.bodyLarge),
    //                           Text('Rizqy Nugroho', style: textTheme.bodyLarge),
    //                           Container(
    //                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //                             decoration: BoxDecoration(
    //                               color: Colors.white,
    //                               borderRadius: BorderRadius.circular(8),
    //                               border: Border.all(color: POSTheme.borderDark),
    //                             ),
    //                             child: const Text('Info Transaksi'),
    //                           ),
    //                           Text('Rp 10.000', style: textTheme.bodyLarge),
    //                         ],
    //                       );
    //                     }),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
  }
}

const Map<int, TableColumnWidth> templateColumnWidths = {
  0: FractionColumnWidth(0.3),
  1: FlexColumnWidth(),
  2: FlexColumnWidth(),
  3: FlexColumnWidth(),
  4: FlexColumnWidth(),
  5: FlexColumnWidth(),
  6: FlexColumnWidth(),
};

const List<Map<String, Object>> mockTransactions = [
  {
    'id': 1,
    'createdAt': '2022-01-01',
    'createdBy': 'Rizqy Nugroho',
    'updatedAt': '2022-01-01',
    'updatedBy': 'Rizqy Nugroho',
    'note': 'Info Transaksi',
    'billType': 'open',
    'saleMode': 1,
    'pax': 1,
    'outletId': '1',
    'sessionId': '1',
    'batchId': 1,
    'batches': [
      {
        'id': 1,
        'at': '2022-01-01',
        'by': 'Rizqy Nugroho',
      },
    ],
    'items': [
      {
        'id': 1,
        'batchId': 1,
        'product': {
          'id': 1,
          'name': 'Product 1',
          'price': 10000,
        },
        'variant': {
          'id': 1,
          'name': 'Variant 1',
          'price': 10000,
        },
        'note': 'Note 1',
        'qty': 1,
        'price': 10000,
        'gross': 10000,
        'discount': 0,
        'net': 10000,
      },
      {
        'id': 2,
        'batchId': 1,
        'product': {
          'id': 1,
          'name': 'Product 1',
          'price': 10000,
        },
        'variant': {
          'id': 1,
          'name': 'Variant 1',
          'price': 10000,
        },
        'note': 'Note 1',
        'qty': 1,
        'price': 10000,
        'gross': 10000,
        'discount': 0,
        'net': 10000,
      },
    ],
  },
];
