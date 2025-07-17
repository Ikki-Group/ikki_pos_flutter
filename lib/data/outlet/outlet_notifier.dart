import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'outlet.model.dart';
import 'outlet_repo.dart';

part 'outlet_notifier.g.dart';

@Riverpod(keepAlive: true)
class OutletNotifier extends _$OutletNotifier {
  @override
  OutletState build() {
    return const OutletState();
  }

  Future<bool> load() async {
    final repo = ref.read(outletRepoProvider);
    final result = await repo.getState();

    if (result == null) {
      return false;
    }

    state = result;
    return true;
  }

  Future<void> setOpen(OutletSessionOpen open) async {
    if (state.session != null) {
      throw Exception('OutletNotifier.setOpen: session is not null');
    }

    final session = OutletSession.initial(open);
    state = state.copyWith(session: session);
    await save();
  }

  Future<void> save() async {
    await ref.read(outletRepoProvider).saveState(state);
  }
}
