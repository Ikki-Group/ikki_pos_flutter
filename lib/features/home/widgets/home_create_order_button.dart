import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/outlet/outlet.provider.dart';
import '../../../widgets/dialogs/outlet_session_open_dialog.dart';
import '../../../widgets/dialogs/sales_mode_dialog.dart';

class HomeCreateOrderButton extends ConsumerStatefulWidget {
  const HomeCreateOrderButton({super.key});

  @override
  ConsumerState<HomeCreateOrderButton> createState() => _HomeCreateOrderButtonState();
}

class _HomeCreateOrderButtonState extends ConsumerState<HomeCreateOrderButton> {
  Future<void> _onPressed() async {
    final outlet = ref.read(outletProvider).requireValue;

    print(outlet.isOpen);

    if (outlet.isOpen) {
      SalesModeDialog.show(context);
    } else {
      OutletSessionOpenDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _onPressed,
      icon: const Icon(Icons.add),
      label: const Text('Buat Pesanan'),
    );
  }
}
