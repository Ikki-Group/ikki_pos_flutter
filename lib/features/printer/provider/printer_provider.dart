import 'dart:async';

import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:objectid/objectid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/talker_logger.dart';
import '../data/printer_repo.dart';
import '../model/printer_enum.dart';
import '../model/printer_model.dart';
import '../templates/printer_utils.dart';
import '../templates/template_print_info.dart';
import 'printer_queue.dart';

part 'printer_provider.g.dart';

const _defaultTimeout = Duration(seconds: 5);
StreamSubscription<List<Printer>>? printerStream;

abstract class PrinterContract {
  Future<void> load();
  Future<bool> requestBluetoothPermissions();
  Future<PrinterModel> bluetoothConnectAndSave(Printer printer);
  Future<PrinterModel> lanConnectAndSave(String name, String host, int port);
  Future<bool> printTemplate(PrinterModel printer, PrinterTemplate template);
  Future<bool> print(
    PrinterTemplate template, {
    PrinterModel? printer,
  });
}

@Riverpod(keepAlive: true, name: 'printerProvider')
class PrinterImpl extends _$PrinterImpl implements PrinterContract {
  final FlutterThermalPrinter instance = FlutterThermalPrinter.instance;
  final PrinterQueue queue = PrinterQueue();

  @override
  List<PrinterModel> build() => [];

  @override
  Future<void> load() async {
    state = await ref.read(printerRepoProvider).getLocal();
    talker.info('[PrinterImpl] load, $state');
  }

  @override
  Future<bool> requestBluetoothPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    final isOn = await instance.isBleTurnedOn();
    logger.debug('isOn: $isOn');

    return statuses.values.every((status) => status.isGranted);
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
      for (final p in event) {
        if (p.connectionType == ConnectionType.BLE && p.name != null && p.name!.isNotEmpty) {
          final isExists = scannedPrinters.any((sp) => sp.name == p.name && sp.address == p.address);
          if (!isExists) {
            scannedPrinters.add(p);
          }
        }
      }
    });

    await Future.delayed(_defaultTimeout, () {
      talker
        ..info('[PrinterImpl] stopScan')
        ..info(scannedPrinters.toString());
      printerStream?.cancel();
      instance.stopScan();
    });

    return scannedPrinters;
  }

  @override
  Future<PrinterModel> bluetoothConnectAndSave(Printer printer) async {
    await instance.connect(printer);
    talker.debug('connected to ${printer.name}');

    final printerModel = PrinterModel(
      id: ObjectId().hexString,
      name: printer.name!,
      connectionType: PrinterConnectionType.bluetooth,
      address: printer.address,
    );

    final printers = state.toList();
    final isExists = state.any((element) => element.address == printer.address);

    await printTemplate(printerModel, PrinterTempInfo(printer));

    if (isExists) {
      talker.debug('printer already exists');
    } else {
      printers.add(printerModel);
      await ref.read(printerRepoProvider).saveLocal(printers);
    }

    state = printers;
    return printerModel;
  }

  @override
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

    final printers = state.toList();
    final isExists = printers.any((element) => element.address == address);

    if (isExists) {
      talker.error('printer already exists');
    } else {
      printers.add(printerModel);
      await ref.read(printerRepoProvider).saveLocal(printers);
    }

    state = printers;
    return printerModel;
  }

  @override
  Future<bool> printTemplate(PrinterModel printerModel, PrinterTemplate template) async {
    final printer = printerModel.printer;
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    await instance.connect(printer);
    template.setup(generator);
    final bytes = await template.build(generator);

    await queue.queue.add(() async {
      final chunk = bytes.splitByLength(182);
      for (final chunk in chunk) {
        await instance.printData(printer, chunk, longData: true);
      }
    });

    return true;
  }

  @override
  Future<bool> print(PrinterTemplate template, {PrinterModel? printer}) async {
    talker.info('[PrinterImpl] print, $state');
    final selectedPrinter = printer ?? state.first;
    // if (selectedPrinter != null) {
    await printTemplate(selectedPrinter, template);
    // }
    return true;
  }
}
