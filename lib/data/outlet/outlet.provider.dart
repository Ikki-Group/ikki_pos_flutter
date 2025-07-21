import 'package:bson/bson.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../user/user.model.dart';
import 'outlet.model.dart';
import 'outlet.repo.dart';

part 'outlet.provider.g.dart';

extension OutletX on OutletModel {
  bool get isOpen {
    return session.id.isNotEmpty;
  }
}

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  @override
  FutureOr<OutletModel> build() {
    return ref.watch(outletRepoProvider).getLocal();
  }

  Future<bool> open(int cash, UserModel user) async {
    var outlet = state.requireValue;
    if (outlet.isOpen) {
      return false;
    }

    outlet = outlet.copyWith(
      session: OutletSessionModel(
        id: ObjectId().toString(),
        open: OutletSessionInfo(
          at: DateTime.now().toIso8601String(),
          by: user.id,
          balance: cash,
          note: '',
        ),
      ),
    );

    await ref.read(outletRepoProvider).save(outlet);
    state = AsyncValue.data(outlet);

    return true;
  }
}
