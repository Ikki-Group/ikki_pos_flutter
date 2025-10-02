import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_constant.dart';
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

extension XOutletState on OutletState {
  bool get isOpen => session?.status == ShiftStatus.open;

  OutletSessionModel get sessionRequired {
    if (session == null) throw Exception('Outlet session is null');
    return session!;
  }

  String get receiptCode {
    final session = sessionRequired;
    final outletCode = outlet.code;
    final deviceCode = device.code;
    final queue = session.queue.toString().padLeft(2, '0');
    final date = DateFormat('yyyyMMdd').format(DateTime.now());

    return '$outletCode/$deviceCode/$date/$queue';
  }
}
