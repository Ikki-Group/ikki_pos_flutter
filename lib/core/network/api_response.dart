import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/utils/exception.dart';

part 'api_response.freezed.dart';

@freezed
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success(T data) = _Success<T>;
  const factory ApiResponse.failure(AppException error) = _Failure;

  const ApiResponse._();
}
