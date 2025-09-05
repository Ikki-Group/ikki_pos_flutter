import 'package:flutter/material.dart';

import '../../../widgets/ui/pos_button.dart';
import '../ui/pos_dialog_two.dart';

class CartNoteDialog extends StatefulWidget {
  const CartNoteDialog({super.key});

  @override
  State<CartNoteDialog> createState() => _CartNoteDialogState();

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const CartNoteDialog();
      },
    );
  }
}

class _CartNoteDialogState extends State<CartNoteDialog> {
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
      title: 'Catatan',
      constraints: const BoxConstraints(minWidth: 600),
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
            maxLines: 3,
            autocorrect: false,
            enableSuggestions: false,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText: 'Catatan Pesanan...',
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
