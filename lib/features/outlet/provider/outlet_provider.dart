import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/model/device_model.dart';
import '../data/outlet_repo.dart';
import '../model/outlet_model.dart';
import '../model/outlet_state.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  @override
  OutletState build() {
    unawaited(load());
    return OutletState.empty();
  }

  Future<OutletState?> load() async {
    final local = await ref.read(outletRepoProvider).getLocalState();
    if (local != null) {
      state = local;
    }
    return local;
  }

  Future<OutletState> syncData(OutletModel outlet, DeviceModel device) async {
    await ref.read(outletRepoProvider).syncLocalState(outlet, device);
    await load();
    return state;
  }

  // // TODO
  // Future<void> onSavedOrder({
  //   required CartState cart,
  //   required CartStatus lastStatus,
  //   List<CartPayment>? newPayments,
  // }) async {
  //   var newState = state.copyWith();
  //   var newSession = newState.session!.copyWith();

  //   if (lastStatus == CartStatus.init) {
  //     newSession = newSession.copyWith(
  //       queue: newSession.queue + 1,
  //       // trxCount: newSession.trxCount + 1,
  //     );
  //   }

  //   if (newPayments != null) {
  //     final amount = newPayments.fold<double>(0, (prev, curr) => prev + curr.amount);
  //     final cashType = newPayments.where((p) => p.type == PaymentType.cash);
  //     final cash = cashType.fold<double>(0, (prev, curr) => prev + curr.amount);

  //     newSession = newSession.copyWith(
  //       // netSales: newSession.netSales + amount,
  //       // cash: newSession.cash + cash,
  //     );
  //   }

  //   newState = newState.copyWith(
  //     session: newSession,
  //   );

  //   await ref.read(outletRepoProvider).saveState(newState);
  // }
}
