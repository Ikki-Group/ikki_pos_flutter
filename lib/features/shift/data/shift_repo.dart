import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/db/shared_prefs.dart';
import '../../../core/logger/talker_logger.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/async_wrapper.dart';
import '../../../utils/json.dart';
import '../../../utils/result.dart';
import '../model/shift_session_model.dart';

part 'shift_repo.g.dart';

@Riverpod(keepAlive: true)
ShiftRepo shiftRepo(Ref ref) {
  return ShiftRepoImpl(
    dio: ref.watch(dioClientProvider),
    sp: ref.watch(sharedPrefsProvider),
  );
}

abstract class ShiftRepo {
  Future<ShiftSessionModel?> getLocalState();
  Future<bool> syncLocalState(ShiftSessionModel? session);

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
  ShiftRepoImpl({required this.dio, required this.sp});

  final Dio dio;
  final SharedPreferences sp;

  @override
  Future<ShiftSessionModel?> getLocalState() async {
    logger.info('[ShiftRepo.getLocalState] start');

    final raw = sp.getString(SharedPrefsKeys.shiftSession.key);
    if (raw == null) {
      logger.info('[ShiftRepo.getLocalState] shift session not found');
      return null;
    }

    final json = posJsonDecode(raw);
    if (json == null) {
      logger.info('[ShiftRepo.getLocalState] shift session is not valid');
      return null;
    }

    logger.info('[ShiftRepo.getLocalState] shift session found');
    return ShiftSessionModel.fromJson(json);
  }

  @override
  Future<bool> syncLocalState(ShiftSessionModel? session) {
    logger.info('[ShiftRepo.syncLocalState] start');

    final result = session != null
        ? sp.setString(SharedPrefsKeys.shiftSession.key, posJsonEncode(session.toJson()))
        : sp.remove(SharedPrefsKeys.shiftSession.key);

    logger.info('[ShiftRepo.syncLocalState] result: $result');
    return result;
  }

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

    logger.debug('close $res');
    return true;
  }
}
