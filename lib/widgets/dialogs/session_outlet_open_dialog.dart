import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/user/user_provider.dart';
import '../../shared/utils/formatter.dart';
import '../ui/pos_dialog.dart';
import 'currency_numpad_dialog.dart';

part 'session_outlet_open_dialog.g.dart';

class SessionOutletOpenDialog extends ConsumerStatefulWidget {
  const SessionOutletOpenDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SessionOutletOpenDialogState();

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const SessionOutletOpenDialog();
      },
    );
  }
}

class _SessionOutletOpenDialogState extends ConsumerState<SessionOutletOpenDialog> {
  int cash = 0;

  void onClose() => Navigator.pop(context);

  void onConfirm() {
    if (cash == 0) return;
    ref.read(confirmActionProvider.notifier).execute(cash);
  }

  Future<void> onTapCash() async {
    final updatedCash = await CurrencyNumpadDialog.show(
      context,
      initialValue: cash,
      placeholder: 'Masukkan Kas Akhir',
      maxDigits: 6,
    );

    if (updatedCash != null) {
      cash = updatedCash;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider).requireValue;
    final user = ref.watch(currentUserProvider)!;

    return PosDialog(
      mainAxisSize: MainAxisSize.min,
      title: 'Buka Toko',
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onClose,
              child: const Text('Batal'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onConfirm,
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
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            outlet.name,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Kasir',
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            user.name,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Kas Awal',
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTapCash,
            child: Container(
              decoration: const UnderlineTabIndicator(
                borderSide: BorderSide(color: POSTheme.primaryBlueDark, width: 1.5),
                insets: EdgeInsets.only(bottom: -8),
              ),
              child: Text(
                cash.toIdr,
                style: textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

@riverpod
class ConfirmAction extends _$ConfirmAction {
  @override
  FutureOr<bool> build() => false;

  Future<void> execute(int cash) async {
    final user = ref.read(currentUserProvider)!;
    await ref.read(outletProvider.notifier).open(cash: cash, user: user);
  }
}
