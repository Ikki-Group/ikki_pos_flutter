import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dio_result_model.freezed.dart';

@freezed
abstract class DioResultModel<T> with _$DioResultModel<T> {
  const factory DioResultModel.success(T data) = Success<T>;
  const factory DioResultModel.failure(DioException error) = Failure<T>;
}
