import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'printer_model.dart';

part 'printer_repo.g.dart';

typedef PrinterList = List<PrinterModel>;

@Riverpod(keepAlive: true)
PrinterRepo printerRepo(Ref ref) {
  return PrinterRepo(
    ref.watch(sharedPrefsProvider),
    ref.watch(dioClientProvider),
  );
}

class PrinterRepo {
  const PrinterRepo(this.sp, this.dio);

  final SharedPreferences sp;
  final Dio dio;

  // Local
  Future<PrinterList> getLocal() async {
    final raw = sp.getString(SharedPrefsKeys.printers.name);
    if (raw == null) {
      return getRemote();
    }
    final json = jsonDecode(raw) as JsonListDynamic;
    return json.map((val) => PrinterModel.fromJson(val as Json)).toList();
  }

  Future<bool> saveLocal(PrinterList printers) async {
    return sp.setString(SharedPrefsKeys.printers.name, jsonEncode(printers));
  }

  // Remote
  Future<PrinterList> getRemote() async {
    return [];
  }

  Future<void> saveRemote() async {}
}
