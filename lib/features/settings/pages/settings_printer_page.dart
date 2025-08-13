import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/add_printer_dialog.dart';

class SettingsPrinterPage extends ConsumerStatefulWidget {
  const SettingsPrinterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPrinterPageState();
}

class _SettingsPrinterPageState extends ConsumerState<SettingsPrinterPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Koneksi Printer', style: textTheme.titleMedium),
            const Spacer(),
            FilledButton(
              onPressed: () => AddPrinterDialog.show(context),
              child: const Text('Tambah Printer'),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Implement MOCK
                ...List.generate(2, PrinterItem.new),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PrinterItem extends StatelessWidget {
  const PrinterItem(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Printer $index'),
      subtitle: const Text('IP: 192.168.1.1'),
    );
  }
}
