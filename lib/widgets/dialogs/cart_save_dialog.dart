import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/ui/pos_button.dart';
import '../../../widgets/ui/pos_dialog_two.dart';
import '../../features/cart/provider/cart_provider.dart';
import '../../router/ikki_router.dart';

class CartSaveDialog extends ConsumerStatefulWidget {
  const CartSaveDialog({super.key});

  @override
  ConsumerState<CartSaveDialog> createState() => _CartSaveDialogState();

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const CartSaveDialog();
      },
    );
  }
}

class _CartSaveDialogState extends ConsumerState<CartSaveDialog> {
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

  Future<void> onSave() async {
    final name = controller.text;
    await ref.read(cartProvider.notifier).saveBill(name);
    if (!mounted) return;
    context.goNamed(IkkiRouter.pos.name);
  }

  @override
  Widget build(BuildContext context) {
    return PosDialogTwo(
      title: 'Simpan Pesanan',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: PosButton.cancel(onPressed: onClose)),
          const SizedBox(width: 8),
          Expanded(child: PosButton.process(onPressed: isValid ? onSave : null)),
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
