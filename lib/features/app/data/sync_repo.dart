import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../utils/json.dart';
import 'sync_dto.dart';

part 'sync_repo.g.dart';

@Riverpod(keepAlive: true)
SyncRepo syncRepo(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return SyncRepoImpl(dio: dio);
}

abstract class SyncRepo {
  Future<OutletDeviceSyncResponseDto> fetchMainData();
}

class SyncRepoImpl implements SyncRepo {
  SyncRepoImpl({required this.dio});

  final Dio dio;

  @override
  Future<OutletDeviceSyncResponseDto> fetchMainData() async {
    final response = await dio.post(ApiConfig.outletDeviceSync, data: {});
    final data = response.data['data'] as Json;

    return OutletDeviceSyncResponseDto.fromJson({
      'device': data['device'] as Json,
      'outlet': data['outlet'] as Json,
      'users': data['accounts'] as dynamic,
    });
  }
}
