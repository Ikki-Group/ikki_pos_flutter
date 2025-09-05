import 'dart:async';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:objectid/objectid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/utils/talker.dart';
import 'printer_enum.dart';
import 'printer_model.dart';
import 'printer_repo.dart';

part 'printer_provider.g.dart';

const _defaultTimeout = Duration(seconds: 5);
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

  Future<List<Printer>> startBluetoothScan() async {
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
          // final isExists = scannedPrinters.any(
          //   (element) => element.name == element.name && element.address == element.address,
          // );
          // if (!isExists) {
          scannedPrinters.add(element);
          // }
        }
      }
    });

    await Future.delayed(_defaultTimeout, () {
      print('[PrinterState] stopScan');
      printerStream?.cancel();
      instance.stopScan();
    });

    return scannedPrinters;
  }

  Future<PrinterModel> bluetoothConnectAndSave(Printer printer) async {
    await instance.connect(printer);
    talker.debug('connected to ${printer.name}');

    final printerModel = PrinterModel(
      id: ObjectId().hexString,
      name: printer.name!,
      connectionType: PrinterConnectionType.bluetooth,
      address: printer.address,
    );

    final printers = await ref.read(printerRepoProvider).getLocal();
    final isExists = printers.any((element) => element.address == printer.address);

    if (isExists) {
      talker.debug('printer already exists');
    } else {
      printers.add(printerModel);
      await ref.read(printerRepoProvider).saveLocal(printers);
    }

    await load();
    return printerModel;
  }

  Future<PrinterModel> lanConnectAndSave(String name, String host, int port) async {
    final address = '$host:$port';

    final printerModel = PrinterModel(
      id: ObjectId().hexString,
      name: name,
      connectionType: PrinterConnectionType.lan,
      host: host,
      port: port,
      address: address,
    );

    final printers = await ref.read(printerRepoProvider).getLocal();
    final isExists = printers.any((element) => element.address == address);

    if (isExists) {
      talker.error('printer already exists');
    } else {
      printers.add(printerModel);
      await ref.read(printerRepoProvider).saveLocal(printers);
    }

    await load();
    return printerModel;
  }
}
