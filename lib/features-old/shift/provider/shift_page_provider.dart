import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/cart/cart_enum.dart';
import '../../../data/cart/cart_provider.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/outlet/outlet_util.dart';
import '../../../data/user/user_provider.dart';

part 'shift_page_provider.g.dart';

@riverpod
class CloseAction extends _$CloseAction {
  @override
  FutureOr<bool> build() => false;

  Future<void> execute() async {
    final user = ref.read(currentUserProvider);
    await ref.read(outletProvider.notifier).close(cash: 1000, user: user!);
  }
}

@riverpod
ShiftSummaryData shiftSummaryData(Ref ref) {
  final outlet = ref.watch(outletProvider);
  final carts = ref.watch(cartDataProvider);

  final data = ShiftSummaryData(
    transactionCount: 0,
    cashBalance: 0,
    productSales: 0,
    transacionVoid: 0,
  );

  final isOpen = outlet.isOpen;
  if (!isOpen) return data;

  final sessionId = outlet.session!.id;
  final list = carts.where((c) => c.sessionId == sessionId && c.status == CartStatus.success).toList();

  final transactionCount = list.length;
  final cashBalance = list.fold<num>(0, (prev, curr) => prev + curr.net);
  final productSales = carts.fold<num>(0, (prev, curr) => prev + curr.items.fold<num>(0, (p, c) => p + c.qty));

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
