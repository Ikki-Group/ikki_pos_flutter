import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutation.freezed.dart';

@freezed
sealed class AppMutation<T> with _$AppMutation<T> {
  const factory AppMutation.idle() = Idle<T>;
  const factory AppMutation.pending() = Pending<T>;
  const factory AppMutation.error(String error) = Error<T>;
  const factory AppMutation.success(T value) = Success<T>;
}
