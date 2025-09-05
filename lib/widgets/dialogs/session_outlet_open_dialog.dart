import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/outlet/outlet_provider.dart';
import '../../../data/user/user_provider.dart';
import '../../data/user/user_util.dart';
import '../../shared/utils/formatter.dart';
import '../../utils/extensions.dart';
import '../ui/pos_button.dart';
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

  Future<void> onConfirm() async {
    if (cash == 0) return;
    await ref.read(confirmActionProvider.notifier).execute(cash);
    if (!mounted) return;
    context.showTextSnackBar('Berhasil membuka toko');
    onClose();
  }

  Future<void> onTapCash() async {
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
    final textTheme = Theme.of(context).textTheme;
    final outlet = ref.watch(outletProvider);
    final user = ref.watch(currentUserProvider).requireValue;

    return PosDialog(
      mainAxisSize: MainAxisSize.min,
      title: 'Buka Toko',
      footer: Row(
        children: [
          Expanded(child: PosButton.cancel(onPressed: onClose)),
          const SizedBox(width: 12),
          Expanded(child: PosButton.process(onPressed: onConfirm)),
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
            outlet.outlet.name,
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
    final user = ref.read(currentUserProvider).requireValue;
    await ref
        .read(outletProvider.notifier)
        .open(
          cash: cash,
          user: user,
        );
  }
}
