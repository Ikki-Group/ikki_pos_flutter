import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/printer/printer_provider.dart';
import '../../../widgets/ui/pos_button.dart';
import '../../../widgets/ui/pos_dialog_two.dart';

class PrinterConnectionLanDialog extends ConsumerStatefulWidget {
  const PrinterConnectionLanDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrinterConnectionLanDialog(),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrinterConnectionLanDialogState();
}

class _PrinterConnectionLanDialogState extends ConsumerState<PrinterConnectionLanDialog> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String host = '';
  int port = 0;

  void onClose() => Navigator.of(context).pop();

  Future<void> onConfirm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    await ref
        .read(printerStateProvider.notifier)
        .lanConnectAndSave(
          name,
          host,
          port,
        );

    // onClose();
  }

  @override
  Widget build(BuildContext context) {
    return PosDialogTwo(
      title: 'LAN/WIFI',
      constraints: const BoxConstraints(minWidth: 500),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          PosButton.cancel(onPressed: onClose),
          const SizedBox(width: 8),
          PosButton.process(
            onPressed: onConfirm,
            text: 'Hubungkan & Simpan',
          ),
        ],
      ),
      children: <Widget>[
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Nama Printer',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama printer tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Host',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Host tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => host = value!,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 8),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Port',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Port tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Port harus berupa angka';
                  }
                  return null;
                },
                onSaved: (value) => port = int.parse(value!),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
