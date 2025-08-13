import 'package:objectid/objectid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../user/user_model.dart';
import 'outlet_model.dart';
import 'outlet_repo.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  @override
  FutureOr<OutletModel> build() => ref.watch(outletRepoProvider).getLocal();

  Future<bool> open({
    required int cash,
    required UserModel user,
    String note = '',
  }) async {
    var outlet = state.requireValue;
    if (outlet.isOpen) throw Exception('Outlet session is already open');

    outlet = outlet.copyWith(
      session: OutletSessionModel(
        id: ObjectId().hexString,
        open: OutletSessionInfo(
          at: DateTime.now().toIso8601String(),
          by: user.id,
          balance: cash,
          note: note,
        ),
      ),
    );

    await ref.read(outletRepoProvider).saveLocal(outlet);
    state = AsyncValue.data(outlet);
    return true;
  }
}

extension OutletX on OutletModel {
  bool get isOpen => session.id.isNotEmpty;

  OutletModel get requireOpen {
    if (!isOpen) throw Exception('Outlet session is not open');
    return this;
  }
}
