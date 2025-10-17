import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../router/app_router.dart';
import '../../../../utils/formatter.dart';
import '../../../../widgets/dialogs/cart_save_dialog.dart';
import '../../model/cart_extension.dart';
import '../../provider/cart_provider.dart';

class CartActions extends ConsumerStatefulWidget {
  const CartActions({super.key});

  @override
  ConsumerState<CartActions> createState() => _CartActionsState();
}

class _CartActionsState extends ConsumerState<CartActions> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final isEmpty = cart.currentItems.isEmpty;

    var label = 'Bayar';
    if (cart.items.isNotEmpty) label += '  |  ${Formatter.toIdr.format(cart.net)}';

    void onPressed() {
      context.goNamed(AppRouter.cartPayment.name);
    }

    return Column(
      children: [
        Row(
          children: [
            _ClearItemsButton(),
            const SizedBox(width: 8),
            _SaveButton(),
            const SizedBox(width: 8),
            // TODO
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.discount_outlined),
                label: const Text('Discount'),
                onPressed: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton(
                onPressed: isEmpty ? null : onPressed,
                child: Text(label),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClearItemsButton extends ConsumerWidget {
  const _ClearItemsButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(cartProvider).items.isEmpty;
    return IconButton.outlined(
      icon: const Icon(Icons.delete_sweep_outlined),
      onPressed: isEmpty
          ? null
          : () {
              ref.read(cartProvider.notifier).clearCurrentItems();
            },
      style: IconButton.styleFrom(
        foregroundColor: AppTheme.accentRed,
        side: const BorderSide(color: AppTheme.accentRed),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final isEmpty = cart.currentItems.isEmpty;

    void onPressed() {
      final hasName = cart.customer?.name.isNotEmpty ?? false;
      if (hasName) {
        ref.read(cartProvider.notifier).saveBill(null).then((_) {
          if (!context.mounted) return;
          context.goNamed(AppRouter.pos.name);
        });
      } else {
        CartSaveDialog.show(context);
      }
    }

    return IconButton.outlined(
      icon: const Icon(Icons.save),
      onPressed: isEmpty ? null : onPressed,
      style: IconButton.styleFrom(
        foregroundColor: AppTheme.primaryBlue,
        side: const BorderSide(color: AppTheme.primaryBlue),
      ),
    );
  }
}
