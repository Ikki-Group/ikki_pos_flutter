import 'package:flutter/material.dart';

import '../../../data/printer/printer_enum.dart';
import '../../../widgets/ui/pos_button.dart';
import '../../../widgets/ui/pos_dialog_two.dart';
import 'printer_connection_bluetooth_dialog.dart';
import 'printer_connection_lan_dialog.dart';

class PrinterConnectionSelectDialog extends StatefulWidget {
  const PrinterConnectionSelectDialog({super.key});

  static Future<void> show(BuildContext context) async {
    final connectionType = await showDialog<PrinterConnectionType>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrinterConnectionSelectDialog(),
    );

    if (connectionType != null && context.mounted) {
      if (connectionType == PrinterConnectionType.bluetooth) {
        await PrinterConnectionBluetoothDialog.show(context);
      } else if (connectionType == PrinterConnectionType.lan) {
        await PrinterConnectionLanDialog.show(context);
      }
    }
  }

  @override
  State<PrinterConnectionSelectDialog> createState() => _PrinterConnectionSelectDialogState();
}

class _PrinterConnectionSelectDialogState extends State<PrinterConnectionSelectDialog> {
  PrinterConnectionType? value;

  void onClose() => Navigator.of(context).pop();

  void onConfirm() => Navigator.of(context).pop(value);

  @override
  Widget build(BuildContext context) {
    return PosDialogTwo(
      title: 'Pilih Koneksi Printer',
      constraints: const BoxConstraints(minWidth: 500),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PosButton.cancel(onPressed: onClose),
          const SizedBox(width: 8),
          PosButton.process(onPressed: value != null ? onConfirm : null),
        ],
      ),
      children: [
        for (final conn in PrinterConnectionType.values)
          CheckboxListTile(
            value: value == conn,
            onChanged: (v) => setState(() => value = conn),
            checkboxScaleFactor: 1.2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text(conn.label),
          ),
      ],
    );
  }
}
