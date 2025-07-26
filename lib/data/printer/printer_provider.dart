import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'printer_model.dart';
import 'printer_repo.dart';
import 'sample.dart';

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
    print('[PrinterProvider] load');
    final printers = await ref.read(printerRepoProvider).load();
    state = printers;
    print('[PrinterProvider] load done');
  }

  Future<void> startScan() async {
    try {
      print('[PrinterProvider] startScan');
      await requestBluetoothPermissions();
      await _devicesStreamSubscription?.cancel();

      await instance.getPrinters(
        connectionTypes: [
          ConnectionType.BLE,
          ConnectionType.NETWORK,
        ],
      );

      _devicesStreamSubscription = instance.devicesStream.listen((List<Printer> event) async {
        // print(event);
        Printer? printer;

        printer = Printer();

        // log(event.map((e) => e.address).toList().toString());
        for (final element in event) {
          if (element.connectionType == ConnectionType.BLE) {
            printer = element;
          }
        }

        if (printer != null) {
          print(jsonEncode(printer));
          final connRes = await instance.connect(printer);
          print('connected: $connRes');

          // final bytes = await _generateReceipt();
          // final bytes = await testTicket();
          // Success
          // final bytes = await customFontSizeTicket();
          final bytes = await completeOptimizedTicket();
          await instance.printData(printer, bytes);
        }
      });
    } catch (e) {
      log('[BLE] Error: $e');
    }
  }

  Future<void> stopScan() async {
    await instance.stopScan();
  }
}

Widget _buildReceiptRow(String leftText, String rightText, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          rightText,
          style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    ),
  );
}

Future<List<int>> _generateReceipt() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  var bytes = <int>[];
  // ignore: join_return_with_assignment
  bytes += generator.text(
    'Teste Network print',
    maxCharsPerLine: 32,
    styles: const PosStyles.defaults().copyWith(align: PosAlign.center),
  );
  // bytes += generator.cut();
  return bytes;
}

Widget receiptWidget(String printerType) {
  return SizedBox(
    width: 550,
    child: Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'FLUTTER THERMAL PRINTER',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            _buildReceiptRow('Item', 'Price'),
            const Divider(),
            _buildReceiptRow('Apple', r'$1.00'),
            _buildReceiptRow('Banana', r'$0.50'),
            _buildReceiptRow('Orange', r'$0.75'),
            const Divider(thickness: 2),
            _buildReceiptRow('Total', r'$2.25', isBold: true),
            const SizedBox(height: 20),
            _buildReceiptRow('Printer Type', printerType),
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Thank you for your purchase!',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
