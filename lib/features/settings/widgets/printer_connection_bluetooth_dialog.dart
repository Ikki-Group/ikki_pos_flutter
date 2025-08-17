import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../../../data/printer/printer_provider.dart';
import '../../../widgets/ui/pos_button.dart';
import '../../../widgets/ui/pos_dialog.dart';

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
  bool isScanning = false;
  bool isEstablishing = false;

  void onClose() => Navigator.of(context).pop();
  void onConfirm() => Navigator.of(context).pop();

  Future<void> onScan() async {
    isScanning = true;
    setState(() {});
    await ref.read(printerStateProvider.notifier).requestBluetoothPermissions();
    printers = await ref.read(printerStateProvider.notifier).startScan();
    isScanning = false;
    isEstablishing = false;
    setState(() {});
  }

  Future<void> onEstablish() async {
    if (selectedPrinter == null) return;
    isEstablishing = true;
    setState(() {});
    await ref.read(printerStateProvider.notifier).instance.connect(selectedPrinter!);
    isEstablishing = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PosDialog(
      title: 'Bluetooth',
      constraints: const BoxConstraints(maxWidth: 480),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PosButton.cancel(onPressed: onClose),
          const SizedBox(width: 8),
          PosButton.process(
            onPressed: selectedPrinter != null ? onConfirm : null,
            text: selectedPrinter != null && isEstablishing ? 'Hubungkan' : 'Simpan',
          ),
        ],
      ),
      children: [
        Row(
          children: [
            Text('Daftar Printer', style: textTheme.titleMedium),
            const Spacer(),
            TextButton.icon(
              onPressed: onScan,
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
