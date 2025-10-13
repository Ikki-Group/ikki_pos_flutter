import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';

import '../../../core/config/app_config.dart';
import '../../../core/db/sembast.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/json.dart';
import '../../../utils/talker.dart';
import '../model/outlet_model.dart';

part 'outlet_session_repo.g.dart';

@Riverpod(keepAlive: true)
OutletSessionRepo outletSessionRepo(Ref ref) {
  final ss = ref.watch(sembastServiceProvider);
  final dio = ref.watch(dioClientProvider);
  return OutletSessionInfoImpl(ss: ss, dio: dio);
}

abstract class OutletSessionRepo {
  Future<List<OutletSessionModel>> list();
  Future<OutletSessionModel?> get(String id);
  Future<void> save(OutletSessionModel session);

  // Rest API
  Future<void> open({
    required String outletId,
    required String by,
    required String at,
    required int balance,
    String? note,
  });
  // Future<void> close();
}

class OutletSessionInfoImpl extends OutletSessionRepo {
  OutletSessionInfoImpl({required this.ss, required this.dio});

  final SembastService ss;
  final Dio dio;

  final StoreRef store = StoreRef('outletSession');

  @override
  Future<List<OutletSessionModel>> list() async {
    final raw = await store.find(ss.db);
    var outletSession = raw.map((e) => OutletSessionModel.fromJson(e.value! as Json)).toList();
    outletSession.sort((a, b) => b.close.at.compareTo(a.close.at));
    return outletSession;
  }

  @override
  Future<OutletSessionModel?> get(String id) async {
    final outletSession = await store.record(id).get(ss.db);
    return outletSession != null ? OutletSessionModel.fromJson(outletSession as Json) : null;
  }

  @override
  Future<void> save(OutletSessionModel session) async {
    await store.record(session.id).put(ss.db, session.toJson());
  }

  @override
  Future<void> open({
    required String outletId,
    required String by,
    required String at,
    required int balance,
    String? note,
  }) async {
    final res = await dio.post(
      ApiConfig.outletShiftOpen,
      data: {
        'outletId': outletId,
        'open': {
          'by': by,
          'at': at,
          'balance': balance,
          'note': note,
        },
      },
    );

    talker.debug('open $res');
  }
}
