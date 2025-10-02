import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../../../utils/extensions.dart';
import '../../../widgets/ui/pos_button.dart';
import '../../../widgets/ui/pos_dialog_two.dart';
import '../../features/printer/provider/printer_provider.dart';

class PrinterConnectionBluetoothDialog extends ConsumerStatefulWidget {
  const PrinterConnectionBluetoothDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrinterConnectionBluetoothDialog(),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrinterConnectionBluetoothDialogState();
}

class _PrinterConnectionBluetoothDialogState extends ConsumerState<PrinterConnectionBluetoothDialog> {
  List<Printer> printers = [];
  Printer? selectedPrinter;
  bool isLoading = false;

  void onClose() => Navigator.of(context).pop();

  Future<void> onScan() async {
    isLoading = true;
    selectedPrinter = null;
    setState(() {});

    await ref
        .read(printerProvider.notifier)
        .startBluetoothScan()
        .then(
          (result) => printers = result,
          onError: (e) {
            if (!mounted) return;
            context.showTextSnackBar(
              'Gagal menemukan printer',
              severity: SnackBarSeverity.error,
            );
          },
        );

    isLoading = false;
    setState(() {});
  }

  Future<void> onConnectAndSave() async {
    if (selectedPrinter == null) return;

    isLoading = true;
    setState(() => {});

    try {
      await ref.read(printerProvider.notifier).bluetoothConnectAndSave(selectedPrinter!);
    } catch (e) {
      if (mounted) {
        context.showTextSnackBar(
          'Gagal menghubungkan printer ${selectedPrinter?.name}',
          severity: SnackBarSeverity.error,
        );
      }
    }

    isLoading = false;
    setState(() {});

    onClose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isScanning = isLoading && selectedPrinter == null;
    final isConnecting = isLoading && selectedPrinter != null;

    return PosDialogTwo(
      title: 'Bluetooth',
      constraints: const BoxConstraints(minWidth: 500),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          PosButton.cancel(onPressed: onClose),
          const SizedBox(width: 8),
          PosButton.process(
            onPressed: selectedPrinter == null || isConnecting ? null : onConnectAndSave,
            text: 'Hubungkan & Simpan',
          ),
        ],
      ),
      children: [
        Row(
          children: [
            Text('Daftar Printer', style: textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: isScanning ? null : onScan,
              icon: isScanning ? null : const Icon(Icons.search),
              label: Text(isScanning ? 'Scanning...' : 'Scan'),
            ),
          ],
        ),
        const Divider(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height * 0.6,
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
                        printer.isConnected = false;
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
