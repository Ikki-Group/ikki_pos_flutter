import 'package:freezed_annotation/freezed_annotation.dart';

part 'outlet_model.freezed.dart';
part 'outlet_model.g.dart';

@freezed
abstract class OutletModel with _$OutletModel {
  const factory OutletModel({
    required String id,
    required String name,
    required String type,
    required String syncAt,
    required String createdAt,
    required String updatedAt,
    required String createdBy,
    required String updatedBy,
  }) = _OutletModel;

  factory OutletModel.fromJson(Map<String, dynamic> json) => _$OutletModelFromJson(json);

  static getMock() {
    return OutletModel(
      id: 'id',
      name: 'Ikki Coffee',
      type: 'type',
      syncAt: "2023-07-01T00:00:00.000Z",
      createdAt: "2023-07-01T00:00:00.000Z",
      updatedAt: "2023-07-01T00:00:00.000Z",
      createdBy: 'createdBy',
      updatedBy: 'updatedBy',
    );
  }
}

@freezed
abstract class OutletSession with _$OutletSession {
  const factory OutletSession({
    required String id,
    required OutletSessionSummary summary,
    OutletSessionOpen? open,
    OutletSessionClose? close,
  }) = _OutletSession;

  factory OutletSession.fromJson(Map<String, dynamic> json) => _$OutletSessionFromJson(json);

  factory OutletSession.initial(OutletSessionOpen? open) {
    return OutletSession(
      id: 'id',
      summary: OutletSessionSummary.initial(),
      open: open,
      close: null,
    );
  }
}

@freezed
abstract class OutletSessionSummary with _$OutletSessionSummary {
  const factory OutletSessionSummary({
    required int trxCount,
    required int trxSuccess,
    required int trxFail,
    required int netSales,
    required int cash,
  }) = _OutletSessionSummary;

  factory OutletSessionSummary.fromJson(Map<String, dynamic> json) => _$OutletSessionSummaryFromJson(json);

  factory OutletSessionSummary.initial() {
    return OutletSessionSummary(
      trxCount: 0,
      trxSuccess: 0,
      trxFail: 0,
      netSales: 0,
      cash: 0,
    );
  }
}

@freezed
abstract class OutletSessionOpen with _$OutletSessionOpen {
  const factory OutletSessionOpen({
    required String at,
    required String by,
    required int balance,
    String? note,
  }) = _OutletSessionOpen;

  factory OutletSessionOpen.fromJson(Map<String, dynamic> json) => _$OutletSessionOpenFromJson(json);
}

@freezed
abstract class OutletSessionClose with _$OutletSessionClose {
  const factory OutletSessionClose({
    required String at,
    required String by,
    required int balance,
    String? note,
  }) = _OutletSessionClose;

  factory OutletSessionClose.fromJson(Map<String, dynamic> json) => _$OutletSessionCloseFromJson(json);
}

@freezed
abstract class OutletState with _$OutletState {
  const OutletState._();

  const factory OutletState({
    OutletModel? outlet,
    OutletSession? session,
  }) = _OutletState;

  factory OutletState.fromJson(Map<String, dynamic> json) => _$OutletStateFromJson(json);

  bool isOpen() {
    return outlet != null && session != null;
  }

  OutletModel get requiredOutlet {
    if (outlet == null) throw Exception("Outlet is null");
    return outlet!;
  }

  OutletSession get requiredSession {
    requiredOutlet;
    if (session == null) throw Exception("Session is null");
    return session!;
  }
}
