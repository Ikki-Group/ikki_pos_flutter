import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/async_wrapper.dart';
import '../../../utils/result.dart';
import '../../../utils/talker.dart';
import '../model/shift_session_model.dart';

part 'shift_repo.g.dart';

@Riverpod(keepAlive: true)
ShiftRepo shiftRepo(Ref ref) {
  return ShiftRepoImpl(
    dio: ref.watch(dioClientProvider),
  );
}

abstract class ShiftRepo {
  Future<ShiftSessionModel?> syncData();
  Future<Result<ShiftSessionModel>> open(
    String outletId,
    ShiftSessionInfo open,
  );
  Future<bool> close(
    String outletId,
    ShiftSessionInfo open,
  );
}

class ShiftRepoImpl implements ShiftRepo {
  ShiftRepoImpl({required this.dio});

  final Dio dio;

  @override
  Future<Result<ShiftSessionModel>> open(
    String outletId,
    ShiftSessionInfo open,
  ) async {
    return AsyncWrapper.run(() async {
      final res = await dio.post(
        ApiConfig.outletShiftOpen,
        data: {
          'outletId': outletId,
          'open': open.toJson(),
        },
      );

      final shift = ShiftSessionModel.fromJson(res.data);
      return shift;
    });
  }

  @override
  Future<bool> close(
    String outletId,
    ShiftSessionInfo open,
  ) async {
    final res = await dio.post(
      ApiConfig.outletShiftClose,
      data: {
        'outletId': outletId,
        'close': open.toJson(),
      },
    );

    talker.debug('close $res');
    return true;
  }

  @override
  Future<ShiftSessionModel?> syncData() {
    throw UnimplementedError();
  }
}
