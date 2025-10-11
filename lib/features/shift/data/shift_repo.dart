import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/shift_session_model.dart';

part 'shift_repo.g.dart';

@Riverpod(keepAlive: true)
ShiftRepo shiftRepo(Ref ref) => ShiftRepoImpl();

abstract class ShiftRepo {
  Future<ShiftSessionModel?> syncData();
  Future<bool> open();
  Future<bool> close();
}

class ShiftRepoImpl implements ShiftRepo {
  @override
  Future<bool> open() {
    throw UnimplementedError();
  }

  @override
  Future<bool> close() {
    throw UnimplementedError();
  }

  @override
  Future<ShiftSessionModel?> syncData() {
    throw UnimplementedError();
  }
}
