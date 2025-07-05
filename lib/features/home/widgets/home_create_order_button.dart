import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/widgets/dialogs/open_outlet_dialog.dart';

class HomeCreateOrderButton extends ConsumerStatefulWidget {
  const HomeCreateOrderButton({super.key});

  @override
  HomeCreateOrderButtonState createState() => HomeCreateOrderButtonState();
}

class HomeCreateOrderButtonState extends ConsumerState<HomeCreateOrderButton> {
  Future<void> _onPressed(BuildContext context) async {
    final outlet = ref.read(outletNotifierProvider);

    OpenOutletDialog.show(context);

    // final isOpen = outlet.isOpen();

    // if (isOpen) {
    //   context.goNamed(IkkiRouter.cartSelection.name);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
      onPressed: () => _onPressed(context),
      icon: const Icon(
        Icons.add,
        size: 24,
      ),
      label: Text(
        "Buat Pesanan",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
