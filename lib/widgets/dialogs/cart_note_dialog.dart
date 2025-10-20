import 'package:flutter/material.dart';

import '../../../widgets/ui/pos_button.dart';
import '../ui/pos_dialog_two.dart';

class CartNoteDialog extends StatefulWidget {
  const CartNoteDialog({super.key, this.defaultValue});

  final String? defaultValue;

  @override
  State<CartNoteDialog> createState() => _CartNoteDialogState();

  static Future<String?> show(BuildContext context, {String defaultValue = ''}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CartNoteDialog(defaultValue: defaultValue);
      },
    );
  }
}

class _CartNoteDialogState extends State<CartNoteDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()
      ..addListener(() {
        setState(() {});
      })
      ..text = widget.defaultValue ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onClose() {
    Navigator.of(context).pop();
  }

  void onSave() {
    Navigator.of(context).pop<String?>(controller.text);
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
          Expanded(child: PosButton.process(onPressed: onSave)),
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
