import 'dart:async';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'printer_model.dart';
import 'printer_repo.dart';

part 'printer_provider.g.dart';

StreamSubscription<List<Printer>>? printerStream;

@Riverpod(keepAlive: true)
class PrinterState extends _$PrinterState {
  final FlutterThermalPrinter instance = FlutterThermalPrinter.instance;

  @override
  List<PrinterModel> build() {
    load();
    return [];
  }

  Future<bool> requestBluetoothPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> load() async {
    state = await ref.read(printerRepoProvider).getLocal();
  }

  Future<List<Printer>> startScan() async {
    await requestBluetoothPermissions();
    await printerStream?.cancel();

    final scannedPrinters = <Printer>[];

    await instance.getPrinters(
      connectionTypes: [
        ConnectionType.BLE,
        ConnectionType.NETWORK,
      ],
    );

    printerStream = instance.devicesStream.listen((List<Printer> event) async {
      for (final element in event) {
        if (element.connectionType == ConnectionType.BLE && element.name != null && element.name!.isNotEmpty) {
          scannedPrinters.add(element);
        }
      }
    });

    await Future.delayed(const Duration(seconds: 5), () {
      print('[PrinterState] stopScan');
      printerStream?.cancel();
      instance.stopScan();
    });

    return scannedPrinters;
  }

  Future<void> stopScan() async {
    await instance.stopScan();
  }
}
