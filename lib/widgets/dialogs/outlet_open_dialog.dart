import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../features/auth/model/user_model.dart';
import '../../features/auth/provider/user_provider.dart';
import '../../features/outlet/provider/outlet_provider.dart';
import '../../shared/utils/formatter.dart';
import '../../utils/extensions.dart';
import '../ui/pos_button.dart';
import '../ui/pos_dialog.dart';
import 'currency_numpad_dialog.dart';

class OutletOpenDialog extends ConsumerStatefulWidget {
  const OutletOpenDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OutletOpenDialogState();

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const OutletOpenDialog();
      },
    );
  }
}

var openOutletMutation = Mutation<void>();

Future<void> executeOpenOutlet(WidgetRef ref, int cash, UserModel user) async {
  await openOutletMutation.run(ref, (tsx) async {
    await ref.read(outletProvider.notifier).openOutlet(cash, user, "");
  });
}

class _OutletOpenDialogState extends ConsumerState<OutletOpenDialog> {
  int cash = 0;

  void onClose() => Navigator.pop(context);

  Future<void> onConfirm() async {
    if (cash == 0) return;
    final user = ref.read(userProvider).selectedUser;
    await executeOpenOutlet(ref, cash, user);
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
    final user = ref.watch(userProvider).selectedUser;
    final mutationState = ref.watch(openOutletMutation);

    return PosDialog(
      mainAxisSize: MainAxisSize.min,
      title: 'Buka Toko',
      footer: Row(
        children: [
          Expanded(child: PosButton.cancel(onPressed: onClose)),
          const SizedBox(width: 12),
          Expanded(
            child: PosButton.process(
              onPressed: onConfirm,
              isLoading: mutationState is MutationPending,
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
                borderSide: BorderSide(color: AppTheme.primaryBlueDark, width: 1.5),
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
