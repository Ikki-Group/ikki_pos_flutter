import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_prefs.dart';
import '../../core/network/dio_client.dart';
import '../json.dart';
import 'printer_model.dart';

part 'printer_repo.g.dart';

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

  Future<List<PrinterModel>> load() async {
    final raw = sp.getString(SharedPrefsKeys.printers.name);
    var printers = <PrinterModel>[];
    if (raw != null) {
      printers = (jsonDecode(raw) as JsonList).map(PrinterModel.fromJson).toList();
    } else {
      printers = await fetch();
    }
    print(printers);
    return printers;
  }

  Future<bool> save(List<PrinterModel> printers) async {
    return sp.setString(SharedPrefsKeys.printers.name, jsonEncode(printers));
  }

  // Remote
  Future<List<PrinterModel>> fetch() async {
    final printers = <PrinterModel>[];
    await save(printers);
    return printers;
  }

  // Local
}
