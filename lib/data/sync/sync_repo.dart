import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/app_endpoints.dart';
import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../user/user_model.dart';
import '../user/user_repo.dart';

part 'sync_repo.g.dart';

@Riverpod(keepAlive: true)
SyncRepo syncRepo(Ref ref) {
  return SyncRepoImpl(
    dio: ref.watch(dioClientProvider),
    sp: ref.watch(sharedPrefsProvider),
    userRepo: ref.watch(userRepoProvider),
  );
}

abstract class SyncRepo {
  Future<void> syncMainData();
}

class SyncRepoImpl implements SyncRepo {
  SyncRepoImpl({required this.dio, required this.sp, required this.userRepo});

  final Dio dio;
  final SharedPreferences sp;
  final UserRepo userRepo;

  @override
  Future<void> syncMainData() async {
    // Fetch
    final res = await dio.post(ApiEndpoints.outletDeviceSync, data: {});

    final users = res.data['data']['users'] as List<UserModel>;
    await userRepo.syncLocal(users);

    throw UnimplementedError();
  }
}
