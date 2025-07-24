import 'dart:async';
import 'dart:developer';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'printer_model.dart';
import 'printer_repo.dart';

part 'printer_provider.g.dart';

@Riverpod(keepAlive: true)
class PrinterProvider extends _$PrinterProvider {
  final FlutterThermalPrinter instance = FlutterThermalPrinter.instance;
  StreamSubscription<List<Printer>>? _devicesStreamSubscription;

  @override
  List<PrinterModel> build() {
    load();
    return [];
  }

  Future<void> load() async {
    print('[PrinterProvider] load');
    final printers = await ref.read(printerRepoProvider).load();
    state = printers;
    print('[PrinterProvider] load done');
  }

  Future<void> startScan() async {
    try {
      await _devicesStreamSubscription?.cancel();
      await instance.getPrinters(
        connectionTypes: [
          ConnectionType.BLE,
          ConnectionType.NETWORK,
        ],
      );

      _devicesStreamSubscription = instance.devicesStream.listen((List<Printer> event) {
        log(event.map((e) => e.name).toList().toString());
      });
    } catch (e) {
      log('[BLE] Error: $e');
    }
  }

  Future<void> stopScan() async {
    await instance.stopScan();
  }
}
