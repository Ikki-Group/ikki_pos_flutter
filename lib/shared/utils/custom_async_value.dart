import 'package:freezed_annotation/freezed_annotation.dart';

import 'exception.dart';

part 'custom_async_value.freezed.dart';

@freezed
sealed class CustomAsyncValue<T> with _$CustomAsyncValue<T> {
  const CustomAsyncValue._();

  const factory CustomAsyncValue.loading() = _Loading<T>;
  const factory CustomAsyncValue.data(T data) = _Data<T>;
  const factory CustomAsyncValue.error(AppException error) = _Error;
}
