import 'package:fpdart/fpdart.dart';
import 'package:ikki_pos_flutter/core/network/api_client.dart';
import 'package:ikki_pos_flutter/data/outlet/model.dart';
import 'package:ikki_pos_flutter/shared/utils/exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repo.g.dart';

@riverpod
OutletRepo outletRepo(ref) {
  final api = ref.watch(apiClientProvider);
  return OutletRepo(api: api);
}

class OutletRepo {
  ApiClient api;

  OutletRepo({required this.api});

  Future<Either<AppException, OutletModel>> getOutlet() async {
    return Right(OutletModel.getMock());
    // try {
    //   final res = await api.dio.get(
    //     ApiEndpoints.outletDetail,
    //     queryParameters: {'id': id},
    //   );

    //   return Right(api.tryParse(res.data, OutletModel.fromJson));
    // } catch (e, st) {
    //   return Left(AppException.fromObject(e, st));
    // }
  }
}
