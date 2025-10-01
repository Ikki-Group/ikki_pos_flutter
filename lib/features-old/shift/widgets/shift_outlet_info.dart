import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/outlet/outlet_provider.dart';
import '../../../data/outlet/outlet_util.dart';
import '../../../shared/utils/formatter.dart';

class ShiftOutletInfo extends ConsumerWidget {
  const ShiftOutletInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider);
    final open = outlet.isOpen ? outlet.session!.open : null;

    final outletInfo = <String, String>{}..putIfAbsent('Nama Toko', () => outlet.outlet.name);
    if (open != null) {
      outletInfo
        ..putIfAbsent('Kas Awal', () => open.cashBalance.toIdr)
        ..putIfAbsent('Waktu', () => open.at);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text('Informasi Buka Toko', style: textTheme.labelLarge),
        ),
        const Divider(),
        const SizedBox(height: 8),
        ...outletInfo.entries.map(
          (e) => ListTile(
            minTileHeight: 0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(e.key),
            subtitle: Text(e.value),
            dense: true,
          ),
        ),
      ],
    );
  }
}
