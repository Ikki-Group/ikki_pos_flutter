import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/pos_theme.dart';
import '../../data/outlet/outlet.provider.dart';
import '../../data/user/user.model.dart';
import '../../data/user/user.provider.dart';
import '../../shared/utils/formatter.dart';
import 'currency_numpad_dialog.dart';
import 'ikki_dialog.dart';

class PosCashOpen extends ConsumerStatefulWidget {
  const PosCashOpen({super.key});

  @override
  ConsumerState<PosCashOpen> createState() => _PosCashOpenState();

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const PosCashOpen();
      },
    );
  }
}

class _PosCashOpenState extends ConsumerState<PosCashOpen> {
  int cash = 0;

  void _onClose() {
    Navigator.pop(context);
  }

  Future<void> _onConfirm(UserModel user) async {
    final result = await ref.read(outletProvider.notifier).open(cash, user);
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (result) {
      Navigator.pop(context);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Berhasil membuka toko'),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Toko sudah terbuka'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _onTapCash() async {
    final updatedCash = await CurrencyNumpadDialog.show(
      context,
      initialValue: cash,
      placeholder: 'Masukkan Kas Awal',
      maxDigits: 6,
    );

    if (updatedCash != null) {
      cash = updatedCash;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletProvider).requireValue;
    final user = ref.watch(currentUserProvider)!;

    return IkkiDialog(
      mainAxisSize: MainAxisSize.min,
      title: 'Buka Toko',
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _onClose,
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _onConfirm(user),
              child: const Text('Proses'),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Outlet',
            style: context.textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            outlet.name,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Kasir',
            style: context.textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            user.name,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Kas Awal',
            style: context.textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: _onTapCash,
            child: Container(
              decoration: const UnderlineTabIndicator(
                borderSide: BorderSide(color: POSTheme.primaryBlueDark, width: 1.5),
                insets: EdgeInsets.only(bottom: -8),
              ),
              child: Text(
                Formatter.toIdr.format(cash),
                style: context.textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
