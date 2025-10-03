import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../sales/provider/sales_provider.dart';
import '../../model/outlet_extension.dart';
import '../../provider/outlet_provider.dart';

part 'shift_notifier.g.dart';

@riverpod
FutureOr<ShiftSummaryData> shiftSummaryData(Ref ref) async {
  final outlet = ref.watch(outletProvider);

  final data = ShiftSummaryData(
    transactionCount: 0,
    cashBalance: 0,
    productSales: 0,
    transacionVoid: 0,
  );

  final isOpen = outlet.isOpen;
  if (!isOpen) return data;

  final sessionId = outlet.session!.id;

  final sales = await ref.watch(salesProvider.future).then((v) => v.where((c) => c.sessionId == sessionId).toList());

  final transactionCount = sales.length;
  final cashBalance = sales.fold<num>(0, (prev, curr) => prev + curr.net);
  final productSales = sales.fold<num>(0, (prev, curr) => prev + curr.items.fold<num>(0, (p, c) => p + c.qty));

  return data
    ..transactionCount = transactionCount
    ..cashBalance = cashBalance
    ..productSales = productSales;
}

class ShiftSummaryData {
  ShiftSummaryData({
    required this.transactionCount,
    required this.cashBalance,
    required this.productSales,
    required this.transacionVoid,
  });
  int transactionCount;
  num cashBalance;
  num productSales;
  int transacionVoid;
}
