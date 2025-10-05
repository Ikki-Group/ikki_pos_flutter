import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/formatter.dart';
import '../../provider/sales_provider.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  late SalesDataSource source;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    source = SalesDataSource(ref);
  }

  @override
  void dispose() {
    source.dispose();
    super.dispose();
  }

  List<DataColumn> get _columns {
    return [
      const DataColumn(
        label: Text('Tanggal & Waktu'),
      ),
      const DataColumn(
        label: Text('ID'),
      ),
      const DataColumn(
        label: Text('Total Item'),
      ),
      const DataColumn(
        label: Text('Total Pembelian'),
        numeric: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final carts = ref.watch(cartDataProvider);
    return Column(
      children: [
        Flexible(
          child: AsyncPaginatedDataTable2(
            availableRowsPerPage: const [2, 5, 10, 30, 100],
            horizontalMargin: 20,
            columnSpacing: 10,
            minWidth: 800,
            columns: _columns,
            empty: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: const Text('Tidak ada data'),
              ),
            ),
            source: source,
          ),
        ),
      ],
    );
  }
}

/// Async datasource for AsynPaginatedDataTabke2 example. Based on AsyncDataTableSource which
/// is an extension to Flutter's DataTableSource and aimed at solving
/// saync data fetching scenarious by paginated table (such as using Web API)
class SalesDataSource extends AsyncDataTableSource {
  SalesDataSource(this.ref) {
    print('SalesDataSource created');
  }

  SalesDataSource.empty(this.ref) {
    print('SalesDataSource.empty created');
  }

  SalesDataSource.error(this.ref) {
    print('SalesDataSource.error created');
  }

  final WidgetRef ref;

  Future<int> getTotalRecords() async {
    final sales = await ref.watch(salesProvider.future);
    return sales.length;
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    assert(startIndex >= 0, 'startIndex must be >= 0');

    // List returned will be empty is there're fewer items than startingAt
    // final x = _empty
    //     ? await Future.delayed(const Duration(milliseconds: 2000), () => DesertsFakeWebServiceResponse(0, []))
    //     : await _repo.getData(startIndex, count);

    final carts = await ref.watch(salesProvider.future);
    print(carts);
    final x = carts;

    final r = AsyncRowsResponse(
      x.length,
      x.map((cart) {
        return DataRow(
          key: ValueKey<String>(cart.id),
          cells: [
            DataCell(Text(Formatter.dateTime.format(DateTime.parse(cart.createdAt)))),
            DataCell(Text(cart.rc)),
            DataCell(Text(cart.items.fold<double>(0, (prev, curr) => prev + curr.gross).toIdr)),
            DataCell(Text(cart.net.toIdr)),
          ],
        );
      }).toList(),
    );

    return r;
  }
}
