import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';

part 'outlet_model.freezed.dart';
part 'outlet_model.g.dart';

@freezed
abstract class OutletModel with _$OutletModel {
  const factory OutletModel({
    required String id,
    required String name,
    required String code,
    String? desc,
    String? email,
    String? phone,
    String? address,
    required String type,
    required String createdAt,
    required String createdBy,
    required String updatedAt,
    required String updatedBy,
  }) = _OutletModel;

  factory OutletModel.fromJson(Json json) => _$OutletModelFromJson(json);

  factory OutletModel.empty() => OutletModel(
    id: '',
    name: '',
    code: '',
    desc: '',
    email: '',
    phone: '',
    address: '',
    type: '',
    createdAt: '',
    createdBy: '',
    updatedAt: '',
    updatedBy: '',
  );
}
