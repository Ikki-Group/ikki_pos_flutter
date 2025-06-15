import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ikki_pos_flutter/shared/utils/exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import './dio_client.dart';

part 'api_client.freezed.dart';
part 'api_client.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ApiClient(dio: dio);
}

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio});

  Future<Either<AppException, List<dynamic>>> getPosts() async {
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/postsas',
      );

      print(response.data);
      final posts = response.data!.map((e) => SamplePost.fromJson(e)).toList();
      return Right(posts);
    } catch (e, st) {
      return Left(AppException.fromObject(e, st));
    }
  }

  tryParse<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    try {
      return fromJson(json['data']);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

@freezed
abstract class SamplePost with _$SamplePost {
  const factory SamplePost({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) = _SamplePost;

  factory SamplePost.fromJson(Map<String, dynamic> json) =>
      _$SamplePostFromJson(json);
}
