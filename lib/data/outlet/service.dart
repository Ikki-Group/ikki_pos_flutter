import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/data/outlet/model.dart';
import 'package:ikki_pos_flutter/data/outlet/repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "service.freezed.dart";
part "service.g.dart";

@Freezed()
abstract class OutletState with _$OutletState {
  const OutletState._();

  const factory OutletState({
    OutletModel? outlet,
    OutletSession? session,
  }) = _OutletState;

  bool isOpen() {
    return outlet != null && session != null;
  }
}

@Riverpod(keepAlive: true)
class OutletService extends _$OutletService {
  @override
  OutletState build() {
    return OutletState();
  }

  Future<bool> load() async {
    final result = await ref.read(outletRepoProvider).getOutlet();
    return result.fold<bool>((l) => false, (r) {
      state = state.copyWith(outlet: r);
      return true;
    });
  }

  Future<void> setOpen(OutletSessionOpen open) async {
    if (state.session != null) {
      throw Exception("OutletService.setOpen: session is not null");
    }

    final session = OutletSession.initial(open);
    state = state.copyWith(session: session);
  }
}
