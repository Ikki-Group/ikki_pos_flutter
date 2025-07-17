import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/outlet/outlet.provider.dart';
import '../../data/user/user.provider.dart';
import '../ui/button_variants.dart';
import '../ui/ikki_dialog.dart';

class OutletSessionOpenDialog extends ConsumerStatefulWidget {
  const OutletSessionOpenDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const OutletSessionOpenDialog();
      },
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OutletSessionOpenDialogState();
}

class _OutletSessionOpenDialogState extends ConsumerState<OutletSessionOpenDialog> {
  late TextEditingController _outletController;

  @override
  void initState() {
    super.initState();
    _outletController = TextEditingController()..value = const TextEditingValue(text: 'Ikki Coffee');
  }

  @override
  void dispose() {
    _outletController.dispose();
    super.dispose();
  }

  void close() {
    Navigator.pop(context);
  }

  Future<void> submit() async {
    final res = await ref.read(outletProvider.notifier).open(20000, 'Rizqy Nugroho');
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (res) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Ikki Smart POS is syncing your data'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Ikki Smart POS is syncing your data'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    close();
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletProvider).requireValue;
    final user = ref.watch(currentUserProvider)!;

    return IkkiDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const IkkiDialogTitle(title: 'Mulai Penjualan'),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Outlet',
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                Text(
                  outlet.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kasir',
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kas Awal',
                  style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Rp. 20.000',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ThemedButton.cancel(
                  onPressed: close,
                ),
                const SizedBox(width: 8),
                ThemedButton.process(
                  onPressed: submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
