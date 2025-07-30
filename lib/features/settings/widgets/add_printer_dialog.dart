import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:fpdart/fpdart.dart' as fp;

import '../../../core/config/pos_theme.dart';
import '../../../data/printer/printer_enum.dart';
import '../../../data/printer/printer_provider.dart';
import '../../../data/printer/sample.dart';
import '../../../widgets/ui/pos_dialog.dart';

class AddPrinterDialog extends StatefulWidget {
  const AddPrinterDialog({super.key});

  @override
  State<AddPrinterDialog> createState() => _AddPrinterDialogState();

  static Future<void> show(BuildContext context) async {
    final connectionType = await showDialog<PrinterConnectionType>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddPrinterDialog(),
    );

    if (connectionType == null) return;

    switch (connectionType) {
      case PrinterConnectionType.bluetooth:
        await showDialog<void>(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (context) => const _PrinterBluetoothDialog(),
        );
      case PrinterConnectionType.lan:
        await showDialog<void>(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (context) => const _PrinterLanDialog(),
          useSafeArea: false,
        );
    }
  }
}

class _AddPrinterDialogState extends State<AddPrinterDialog> {
  PrinterConnectionType? value;

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    if (value == null) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final allowNext = value != null;

    return PosDialog(
      title: 'Pilih Koneksi Printer',
      constraints: const BoxConstraints(maxWidth: 480),
      footer: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: _onClose,
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: allowNext ? _onConfirm : null,
              child: const Text('Terapkan'),
            ),
          ),
        ],
      ),
      children: [
        for (final conn in PrinterConnectionType.values)
          CheckboxListTile(
            value: value == conn,
            onChanged: (v) => setState(() => value = conn),
            checkboxScaleFactor: 1.2,
            title: Text(conn.label),
          ),
      ],
    );
  }
}

class _PrinterBluetoothDialog extends ConsumerStatefulWidget {
  const _PrinterBluetoothDialog();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __PrinterBluetoothDialogState();
}

class __PrinterBluetoothDialogState extends ConsumerState<_PrinterBluetoothDialog> {
  final FlutterThermalPrinter instance = FlutterThermalPrinter.instance;

  Printer? selectedPrinter;
  bool isScanning = false;
  bool isLoading = false;
  List<Printer> printers = [];
  StreamSubscription<List<Printer>>? devicesStreamSubscription;

  void onClose() {
    Navigator.of(context).pop();
  }

  Future<void> onConfirm() async {
    if (selectedPrinter == null) return;
    isLoading = true;
    await instance.connect(selectedPrinter!);
    await onTest(selectedPrinter!);
    setState(() {});

    // Navigator.of(context).pop();
  }

  Future<void> scan() async {
    isScanning = true;
    selectedPrinter = null;
    setState(() {});

    await ref.read(printerProviderProvider.notifier).requestBluetoothPermissions();
    await instance.getPrinters(connectionTypes: [ConnectionType.BLE]);

    devicesStreamSubscription = instance.devicesStream.listen((List<Printer> rawPrinters) async {
      printers = rawPrinters.filter((p) => p.name != null && p.name!.isNotEmpty).toList();
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 5), () {
      print('[PrinterProvider] stopScan');
      devicesStreamSubscription?.cancel();
      instance.stopScan();
      isScanning = false;
      setState(() {});
    });
  }

  Future<void> onTest(Printer printer) async {
    print('Test Printer: ${printer.name}');
    try {
      final bytes = await receiptSample();
      final chunks = bytes.splitByLength(100);
      for (final chunk in chunks) {
        await instance.printData(printer, chunk, longData: true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allowNext = selectedPrinter != null;

    return PosDialog(
      title: 'Printer Bluetooth',
      constraints: const BoxConstraints(maxWidth: 480),
      footer: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: onClose,
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: allowNext ? onConfirm : null,
              child: const Text('Sambungkan'),
            ),
          ),
        ],
      ),
      children: [
        Row(
          children: [
            Text('Daftar Printer', style: context.textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: scan,
              icon: isScanning ? null : const Icon(Icons.search),
              label: Text(isScanning ? 'Scanning...' : 'Scan'),
            ),
          ],
        ),
        const Divider(),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: isScanning
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: printers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final printer = printers.elementAt(index);
                    return CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      title: Text(printer.name!),
                      subtitle: Text(printer.address!),
                      value: printer.address == selectedPrinter?.address,
                      onChanged: (bool? value) {
                        selectedPrinter = printer;
                        setState(() {});
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _PrinterLanDialog extends ConsumerStatefulWidget {
  const _PrinterLanDialog();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __PrinterLanDialogState();
}

class __PrinterLanDialogState extends ConsumerState<_PrinterLanDialog> {
  bool allowNext = false;

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // final allowNext = selected != null;

    return PosDialog(
      title: 'Printer LAN/WIFI',
      constraints: const BoxConstraints(maxWidth: 480),
      footer: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: _onClose,
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: allowNext ? _onConfirm : null,
              child: const Text('Sambungkan'),
            ),
          ),
        ],
      ),
      children: [
        const Text('Host'),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Masukkan Host',
          ),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 8),
        const Text('Port'),
        const SizedBox(height: 8),
        TextField(
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: const InputDecoration(
            hintText: 'Masukkan Port',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
