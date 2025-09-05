import 'package:flutter/material.dart';

import '../../../widgets/ui/pos_button.dart';
import '../ui/pos_dialog_two.dart';

class CartCashCustom extends StatefulWidget {
  const CartCashCustom({super.key});

  @override
  State<CartCashCustom> createState() => _CartCashCustomState();

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const CartCashCustom();
      },
    );
  }
}

class _CartCashCustomState extends State<CartCashCustom> {
  late TextEditingController controller;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()
      ..addListener(() {
        setState(() {
          isValid = controller.text.isNotEmpty;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PosDialogTwo(
      title: 'Masukkan Nominal',
      constraints: const BoxConstraints(minWidth: 400),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: PosButton.cancel(onPressed: onClose)),
          const SizedBox(width: 8),
          Expanded(child: PosButton.process(onPressed: isValid ? onClose : null)),
        ],
      ),
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Nominal',
              hintStyle: TextStyle(fontSize: 14),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}
