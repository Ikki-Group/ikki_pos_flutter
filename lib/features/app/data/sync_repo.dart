import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/json.dart';
import '../model/device_sync_dto.dart';

part 'sync_repo.g.dart';

@Riverpod(keepAlive: true)
SyncRepo syncRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return SyncRepoImpl(dio: dio);
}

abstract class SyncRepo {
  Future<DeviceSyncResponseDto> deviceSync();
}

class SyncRepoImpl implements SyncRepo {
  SyncRepoImpl({required this.dio});

  final Dio dio;

  @override
  Future<DeviceSyncResponseDto> deviceSync() async {
    final response = await dio.post(ApiConfig.outletDeviceSync, data: {});
    final data = response.data['data'] as Json;
    return DeviceSyncResponseDto.fromJson(data);
  }
}
