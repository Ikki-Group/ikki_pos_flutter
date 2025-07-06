import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String name,
    required String email,
    required String pin,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static List<User> getMock() {
    return List.generate(10, (index) {
      return User(
        id: '$index',
        name: 'Rizqy Nugroho $index',
        email: 'rizqy.nugroho$index@ikki.id',
        pin: '1111',
      );
    });
  }

  static int kPinLength = 4;

  bool comparePin(String pin) {
    return pin == this.pin;
  }
}
