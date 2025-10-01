import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../model/device_model.dart';
import '../../../model/outlet_model.dart';
import '../../../utils/json.dart';

part 'outlet_state.freezed.dart';
part 'outlet_state.g.dart';

@freezed
abstract class OutletState with _$OutletState {
  const factory OutletState({
    required OutletModel outlet,
    required DeviceModel device,
    @Default(null) OutletSessionModel? session,
  }) = _OutletState;

  factory OutletState.fromJson(Json json) => _$OutletStateFromJson(json);

  factory OutletState.empty() => OutletState(
    outlet: OutletModel.empty(),
    device: DeviceModel.empty(),
    session: null,
  );
}
