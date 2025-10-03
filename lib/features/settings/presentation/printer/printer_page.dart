import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/dialogs/printer_connection_select_dialog.dart';
import '../../../printer/model/printer_enum.dart';
import '../../../printer/model/printer_model.dart';
import '../../../printer/provider/printer_provider.dart';

class PrinterPage extends ConsumerStatefulWidget {
  const PrinterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrinterPageState();
}

class _PrinterPageState extends ConsumerState<PrinterPage> {
  void onAdd() {
    PrinterConnectionSelectDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final printers = ref.watch(printerProvider);

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
          child: printers.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          'Tambahkan printer',
                          style: context.textTheme.bodyMedium?.copyWith(color: AppTheme.textOnSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
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
