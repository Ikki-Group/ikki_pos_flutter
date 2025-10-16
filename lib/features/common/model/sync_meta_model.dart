import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/json.dart';

part 'sync_meta_model.freezed.dart';
part 'sync_meta_model.g.dart';

enum SyncStatus {
  idle,
  success,
  fail,
}

@freezed
abstract class SyncMetaModel with _$SyncMetaModel {
  const factory SyncMetaModel({
    required SyncStatus status,
    required DateTime updatedAt,
  }) = _SyncMetaModel;

  factory SyncMetaModel.fromJson(Json json) => _$SyncMetaModelFromJson(json);

  /// Init from REST API
  /// Status = success
  factory SyncMetaModel.initFromRest() => SyncMetaModel(
    status: SyncStatus.success,
    updatedAt: DateTime.now(),
  );
}
