import 'package:freezed_annotation/freezed_annotation.dart';

part 'outlet.model.freezed.dart';
part 'outlet.model.g.dart';

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
}

@freezed
abstract class OutletSessionModel with _$OutletSessionModel {
  const factory OutletSessionModel({
    required String id,
    @Default(OutletSessionSummaryModel()) OutletSessionSummaryModel summary,

    // OutletSessionOpen? open,
    // OutletSessionClose? close,
  }) = _OutletSessionModel;
}

@freezed
abstract class OutletSessionSummaryModel with _$OutletSessionSummaryModel {
  const factory OutletSessionSummaryModel({
    @Default(0) int trxCount,
    @Default(0) int trxSuccess,
    @Default(0) int trxFail,
    @Default(0) int netSales,
    @Default(0) int cash,
  }) = _OutletSessionSummaryModel;
}

// @freezed
// abstract class OutletSessionOpen with _$OutletSessionOpen {
//   const factory OutletSessionOpen({
//     required String at,
//     required String by,
//     required int balance,
//     String? note,
//   }) = _OutletSessionOpen;

//   factory OutletSessionOpen.fromJson(Map<String, dynamic> json) => _$OutletSessionOpenFromJson(json);
// }

// @freezed
// abstract class OutletSessionClose with _$OutletSessionClose {
//   const factory OutletSessionClose({
//     required String at,
//     required String by,
//     required int balance,
//     String? note,
//   }) = _OutletSessionClose;

//   factory OutletSessionClose.fromJson(Map<String, dynamic> json) => _$OutletSessionCloseFromJson(json);
// }

// @freezed
// abstract class OutletState with _$OutletState {
//   const factory OutletState({
//     OutletModel? outlet,
//     OutletSession? session,
//   }) = _OutletState;
//   const OutletState._();

//   factory OutletState.fromJson(Map<String, dynamic> json) => _$OutletStateFromJson(json);

//   bool isOpen() {
//     return outlet != null && session != null;
//   }

//   OutletModel get requiredOutlet {
//     if (outlet == null) throw Exception('Outlet is null');
//     return outlet!;
//   }

//   OutletSession get requiredSession {
//     requiredOutlet;
//     if (session == null) throw Exception('Session is null');
//     return session!;
//   }
// }
