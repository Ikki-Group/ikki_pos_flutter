import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/core/config/pos_theme.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/data/user/user_notifier.dart';
import 'package:ikki_pos_flutter/shared/utils/formatter.dart';
import 'package:ikki_pos_flutter/widgets/dialogs/currency_numpad_dialog.dart';
import 'package:ikki_pos_flutter/widgets/ui/button_variants.dart';
import 'package:ikki_pos_flutter/widgets/ui/ikki_dialog.dart';

class OpenOutletDialog extends ConsumerStatefulWidget {
  const OpenOutletDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OpenOutletDialog();
      },
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OpenOutletDialogState();
}

class _OpenOutletDialogState extends ConsumerState<OpenOutletDialog> {
  @override
  void initState() {
    super.initState();
  }

  _onCashInPressed() {
    CurrencyNumpadDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletNotifierProvider).requiredOutlet;
    final user = ref.watch(userNotifierProvider);

    return IkkiDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            IkkiDialogTitle(title: "Mulai Penjualan"),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text("Kasir"),
                    Text(
                      user!.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Outlet"),
                    Text(
                      outlet.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Kas Awal"),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _onCashInPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: POSTheme.primaryBlueLight,
                          side: const BorderSide(color: POSTheme.primaryBlueLight, width: 1),
                          shape: const LinearBorder(
                            side: BorderSide(color: Colors.blue),
                            bottom: LinearBorderEdge(),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(Formatter.toIdr.format(0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ThemedButton.cancel(
                  size: ButtonSize.medium,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                ThemedButton.process(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
