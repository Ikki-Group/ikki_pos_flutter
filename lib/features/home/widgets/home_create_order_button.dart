import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/outlet/outlet_notifier.dart';
import 'package:ikki_pos_flutter/widgets/dialogs/open_outlet_dialog.dart';
import 'package:ikki_pos_flutter/widgets/ui/button_variants.dart';

class HomeCreateOrderButton extends ConsumerStatefulWidget {
  const HomeCreateOrderButton({super.key});

  @override
  HomeCreateOrderButtonState createState() => HomeCreateOrderButtonState();
}

class HomeCreateOrderButtonState extends ConsumerState<HomeCreateOrderButton> {
  Future<void> _onPressed() async {
    final outlet = ref.read(outletNotifierProvider);

    OpenOutletDialog.show(context);

    // final isOpen = outlet.isOpen();

    // if (isOpen) {
    //   context.goNamed(IkkiRouter.cartSelection.name);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedButton(
      onPressed: () => _onPressed(),
      icon: const Icon(
        Icons.add,
        size: 24,
      ),
      text: 'Buat Pesanan',
    );
  }
}
