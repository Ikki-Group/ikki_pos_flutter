import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../widgets/dialogs/outlet_open_dialog.dart';
import '../../../widgets/dialogs/sales_mode_dialog.dart';
import '../../outlet/data/outlet_state.dart';
import '../../outlet/provider/outlet_provider.dart';
import '../provider/cart_provider.dart';

class CreateOrderButton extends ConsumerStatefulWidget {
  const CreateOrderButton({super.key});

  @override
  ConsumerState<CreateOrderButton> createState() => _CreateOrderButtonState();
}

class _CreateOrderButtonState extends ConsumerState<CreateOrderButton> {
  Future<void> _onPressed() async {
    final outlet = ref.read(outletProvider);

    if (!outlet.isOpen) {
      await OutletOpenDialog.show(context);
    } else {
      ref.read(cartProvider.notifier).reset();
      SalesModeDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.backgroundPrimary,
        foregroundColor: AppTheme.primaryBlueDark,
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
