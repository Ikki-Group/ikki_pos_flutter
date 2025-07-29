import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cart/cart_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          _HeaderSection(),
          _CartTable(),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget buildChip(
      String label,
      bool selected,
    ) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Online',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Row(
      children: [
        buildChip('Semua', false),
        buildChip('Kasir', false),
        buildChip('Order Online', false),
      ],
    );
  }
}

class _CartTable extends StatelessWidget {
  const _CartTable();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('Order ID', style: textTheme.titleSmall),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('Nama', style: textTheme.titleSmall),
            ),
            TableCell(child: Text('Tanggal', style: textTheme.titleSmall)),
            TableCell(child: Text('Status', style: textTheme.titleSmall)),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('Tagihan', style: textTheme.titleSmall, textAlign: TextAlign.right),
            ),
          ],
        ),
      ],
    );
  }
}
