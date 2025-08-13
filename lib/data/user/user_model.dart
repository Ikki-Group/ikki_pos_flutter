import 'package:freezed_annotation/freezed_annotation.dart';

import '../json.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required String pin,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Json json) => _$UserModelFromJson(json);

  static List<UserModel> fromJsonList(JsonList json) => json.map(UserModel.fromJson).toList();

  static const int kPinLength = 4;

  bool comparePin(String pin) => pin == this.pin;
}
