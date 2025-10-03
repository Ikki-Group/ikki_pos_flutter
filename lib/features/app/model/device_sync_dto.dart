import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';
import '../../auth/model/user_model.dart';
import '../../outlet/model/outlet_model.dart';
import '../../product/model/product_model.dart';
import 'device_model.dart';

part 'device_sync_dto.freezed.dart';
part 'device_sync_dto.g.dart';

@Freezed(toJson: false)
abstract class DeviceSyncResponseDto with _$DeviceSyncResponseDto {
  const factory DeviceSyncResponseDto({
    required DeviceModel device,
    required OutletModel outlet,
    required List<UserModel> accounts,
    required List<ProductModel> products,
    required List<ProductCategoryModel> categories,
  }) = _DeviceSyncResponseDto;

  factory DeviceSyncResponseDto.fromJson(Json json) => _$DeviceSyncResponseDtoFromJson(json);
}
