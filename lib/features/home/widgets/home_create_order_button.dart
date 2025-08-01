import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet.provider.dart';
import '../../../widgets/dialogs/pos_cash_open.dart';
import '../../../widgets/dialogs/sales_mode_dialog.dart';

class HomeCreateOrderButton extends ConsumerStatefulWidget {
  const HomeCreateOrderButton({super.key});

  @override
  ConsumerState<HomeCreateOrderButton> createState() => _HomeCreateOrderButtonState();
}

class _HomeCreateOrderButtonState extends ConsumerState<HomeCreateOrderButton> {
  Future<void> _onPressed() async {
    final outlet = await ref.read(outletProvider.future);
    if (!mounted) return;

    if (!outlet.isOpen) {
      await PosCashOpen.show(context);
    } else {
      SalesModeDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: POSTheme.backgroundPrimary,
        foregroundColor: POSTheme.primaryBlueDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: _onPressed,
      icon: const Icon(Icons.add),
      label: const Text('Buat Pesanan'),
    );
  }
}
