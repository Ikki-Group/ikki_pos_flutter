import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/printer/printer_enum.dart';
import '../../../data/printer/printer_model.dart';
import '../../../data/printer/printer_provider.dart';
import '../widgets/printer_connection_select_dialog.dart';

class SettingsPrinterPage extends ConsumerStatefulWidget {
  const SettingsPrinterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPrinterPageState();
}

class _SettingsPrinterPageState extends ConsumerState<SettingsPrinterPage> {
  void onAdd() {
    PrinterConnectionSelectDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final printers = ref.watch(printerStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Koneksi Printer', style: textTheme.titleMedium),
            const Spacer(),
            FilledButton(
              onPressed: onAdd,
              child: const Text('Tambah Printer'),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              for (final printer in printers)
                _PrinterItem(
                  printer: printer,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrinterItem extends StatelessWidget {
  const _PrinterItem({required this.printer});

  final PrinterModel printer;

  @override
  Widget build(BuildContext context) {
    String subtitle;

    switch (printer.connectionType) {
      case PrinterConnectionType.bluetooth:
        subtitle = 'Bluetooth - ${printer.address}';
      case PrinterConnectionType.lan:
        subtitle = 'LAN/WIFI - ${printer.host}:${printer.port}';
    }

    return ListTile(
      style: ListTileStyle.list,
      minLeadingWidth: 0,
      onTap: () {},
      enableFeedback: true,
      contentPadding: EdgeInsets.zero,
      title: Text(printer.name),
      subtitle: Text(subtitle),
      leading: const Icon(Icons.print),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
