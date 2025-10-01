import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/config/app_constant.dart';
import '../data/json.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required String pin,
    required String status,
    required bool isRoot,
    required String createdAt,
    required String updatedAt,
    required String createdBy,
    required String updatedBy,
    @Default([]) List<UserOutletModel> outlets,
  }) = _UserModel;

  factory UserModel.fromJson(Json json) => _$UserModelFromJson(json);

  factory UserModel.empty() => UserModel(
    id: '',
    name: '',
    email: '',
    pin: '',
    status: '',
    isRoot: false,
    createdAt: '',
    updatedAt: '',
    createdBy: '',
    updatedBy: '',
    outlets: [],
  );
}

@freezed
abstract class UserOutletModel with _$UserOutletModel {
  const factory UserOutletModel({
    required String oId,
    required UserRole role,
    @Default(false) bool isDefault,
  }) = _UserOutletModel;

  factory UserOutletModel.fromJson(Json json) => _$UserOutletModelFromJson(json);
}
