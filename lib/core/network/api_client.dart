// import 'package:dio/dio.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '../../shared/utils/exception.dart';
// import './dio_client.dart';

// part 'api_client.freezed.dart';
// part 'api_client.g.dart';

// @Riverpod(keepAlive: true)
// ApiClient apiClient(Ref ref) {
//   final dio = ref.watch(dioClientProvider);
//   return ApiClient(dio: dio);
// }

// class ApiClient {
//   ApiClient({required this.dio});
//   final Dio dio;

//   Future<Either<AppException, List<dynamic>>> getPosts() async {
//     try {
//       final response = await dio.get(
//         'https://jsonplaceholder.typicode.com/postsas',
//       );

//       print(response.data);
//       final posts = response.data!.map((e) => SamplePost.fromJson(e as Map<String, dynamic>));
//       return Right(posts as List<dynamic>);
//     } catch (e, st) {
//       return Left(AppException.fromObject(e, st));
//     }
//   }

//   T tryParse<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
//     try {
//       return fromJson(json['data'] as Map<String, dynamic>);
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }
// }

// @freezed
// abstract class SamplePost with _$SamplePost {
//   const factory SamplePost({
//     required int userId,
//     required int id,
//     required String title,
//     required String body,
//   }) = _SamplePost;

//   factory SamplePost.fromJson(Map<String, dynamic> json) => _$SamplePostFromJson(json);
// }
