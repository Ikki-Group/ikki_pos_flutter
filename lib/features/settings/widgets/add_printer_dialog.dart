import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/printer/printer_enum.dart';
import '../../../data/printer/printer_provider.dart';
import '../../../widgets/dialogs/ikki_dialog.dart';

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

    return IkkiDialog(
      title: 'Pilih Koneksi Printer',
      mainAxisSize: MainAxisSize.min,
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
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                for (final conn in PrinterConnectionType.values)
                  CheckboxListTile(
                    value: value == conn,
                    onChanged: (v) => setState(() => value = conn),
                    checkboxScaleFactor: 1.2,
                    title: Text(conn.label),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterBluetoothDialog extends ConsumerStatefulWidget {
  const _PrinterBluetoothDialog();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __PrinterBluetoothDialogState();
}

class __PrinterBluetoothDialogState extends ConsumerState<_PrinterBluetoothDialog> {
  String? selected;

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onConfirm() {
    Navigator.of(context).pop();
  }

  void _scan() {
    ref.read(printerProviderProvider.notifier).startScan().catchError((_) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tidak dapat menemukan printer'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final allowNext = selected != null;

    return IkkiDialog(
      title: 'Printer Bluetooth',
      mainAxisSize: MainAxisSize.min,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text('Daftar Printer'),
              const Spacer(),
              TextButton(
                onPressed: _scan,
                child: const Text('Pindai'),
              ),
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                final value = index.toString();
                return CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  title: Text('Printer $index'),
                  subtitle: const Text('IP: 192.168.1.1'),
                  value: selected == value,
                  onChanged: (_) {
                    setState(() {
                      selected = value;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
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

    return IkkiDialog(
      title: 'Printer LAN/WIFI',
      mainAxisSize: MainAxisSize.min,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}
