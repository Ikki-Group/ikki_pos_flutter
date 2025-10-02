import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/db/shared_prefs.dart';
import '../../../core/network/dio_client.dart';
import '../../../model/printer_model.dart';
import '../../../utils/json.dart';

part 'printer_repo.g.dart';

@Riverpod(keepAlive: true)
PrinterRepo printerRepo(Ref ref) {
  return PrinterRepoImpl(
    ref.watch(sharedPrefsProvider),
    ref.watch(dioClientProvider),
  );
}

abstract class PrinterRepo {
  Future<List<PrinterModel>> getState();
  Future<List<PrinterModel>> getLocal();
  Future<bool> saveLocal(List<PrinterModel> printers);
}

class PrinterRepoImpl implements PrinterRepo {
  const PrinterRepoImpl(this.sp, this.dio);

  final SharedPreferences sp;
  final Dio dio;

  @override
  Future<List<PrinterModel>> getState() async {
    final local = await getLocal();
    return local;
  }

  @override
  Future<List<PrinterModel>> getLocal() async {
    final raw = sp.getStringList(SharedPrefsKeys.printers.key);
    if (raw != null) {
      final jsonList = posJsonDecodeList(raw);
      return jsonList.map(PrinterModel.fromJson).toList();
    }
    return [];
  }

  @override
  Future<bool> saveLocal(List<PrinterModel> printers) async {
    return sp.setStringList(
      SharedPrefsKeys.printers.key,
      printers.map(jsonEncode).toList(),
    );
  }
}
