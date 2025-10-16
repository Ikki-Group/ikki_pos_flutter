import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class Foo extends _$Foo {
  @override
  FutureOr<String> build() => 'foo';
}
