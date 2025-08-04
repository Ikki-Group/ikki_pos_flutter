import 'package:flutter/material.dart';

import '../../../widgets/ui/pos_button.dart';
import '../../../widgets/ui/pos_dialog.dart';

class CartSaveDialog extends StatefulWidget {
  const CartSaveDialog({super.key});

  @override
  State<CartSaveDialog> createState() => _CartSaveDialogState();

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const CartSaveDialog();
      },
    );
  }
}

class _CartSaveDialogState extends State<CartSaveDialog> {
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
    return PosDialog(
      title: 'Simpan Pesanan',
      constraints: const BoxConstraints(maxWidth: 500),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: PosButton.cancel(onPressed: onClose)),
          const SizedBox(width: 8),
          Expanded(child: PosButton.process(onPressed: isValid ? onClose : null)),
        ],
      ),
      children: [
        Text('Nama Pesanan', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText: 'Masukkan Nama Pelanggan atau Nomor Meja',
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
