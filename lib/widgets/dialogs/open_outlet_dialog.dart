import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/data/user/user_notifier.dart';
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
  OpenOutletDialogState createState() => OpenOutletDialogState();
}

class OpenOutletDialogState extends ConsumerState<OpenOutletDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final outlet = ref.watch(outletNotifierProvider).requiredOutlet;
    final user = ref.watch(userNotifierProvider);

    return IkkiDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    children: [
                      Text(
                        "Outlet",
                      ),
                      Text(outlet.name),
                      const SizedBox(height: 8),
                      Text("Kasir"),
                      Text(user!.name),
                      const SizedBox(height: 8),
                      Text("Kas Awal"),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          fillColor: Colors.transparent,
                          hint: Text("Rp. 0"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {},
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
