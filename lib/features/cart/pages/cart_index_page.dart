import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_extension.dart';
import '../../../data/cart/cart_state.dart';
import '../../../router/ikki_router.dart';
import '../../../shared/utils/formatter.dart';
import '../widgets/cart_categories.dart';
import '../widgets/cart_index_widgets.dart';
import '../widgets/cart_items.dart';
import '../widgets/cart_products.dart';

class CartIndexPage extends ConsumerWidget {
  const CartIndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ColoredBox(
      color: POSTheme.backgroundSecondary,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _Header(),
                  SizedBox(height: 16),
                  CartCategories(),
                  SizedBox(height: 16),
                  _ProductFilterSection(),
                  SizedBox(height: 16),
                  CartProducts(),
                ],
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CartSalesModeInfo(),
                    SizedBox(height: 12),
                    CartItems(),
                    SizedBox(height: 12),
                    CartSummaryExpanded(),
                    SizedBox(height: 12),
                    _CartAction(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onBack() {
      context.goNamed(IkkiRouter.pos.name);
      ref.read(cartStateProvider.notifier).reset();
    }

    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.home, size: 24, color: POSTheme.textOnSecondary),
          onPressed: onBack,
        ),
        const SizedBox(width: 8),
        const BadgeReceiptCode(),
        const Spacer(),
        // const CustomerInfo(name: 'name', email: 'email@email.com'),
      ],
    );
  }
}

class _ProductFilterSection extends ConsumerWidget {
  const _ProductFilterSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        const IconButton(onPressed: null, icon: Icon(Icons.align_horizontal_left_sharp)),
        const SizedBox(width: 8),
        const CartSearchProduct(),
        const SizedBox(width: 8),
        TextButton.icon(onPressed: null, icon: const Icon(Icons.add), label: const Text('Custom Amount')),
      ],
    );
  }
}

class _CartAction extends ConsumerWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartStateProvider);

    var label = 'Bayar';
    if (cart.isItemEmpty) label += '  |  ${Formatter.toIdr.format(cart.net)}';

    void onPressed() {
      context.goNamed(IkkiRouter.cartPayment.name);
    }

    void onSave() {
      ref.read(cartStateProvider.notifier).save();
      context.goNamed(IkkiRouter.pos.name);
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => ref.read(cartStateProvider.notifier).clearAllItems(),
              style: IconButton.styleFrom(
                foregroundColor: POSTheme.accentRed,
                side: const BorderSide(color: POSTheme.accentRed),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              icon: const Icon(Icons.save),
              onPressed: cart.isItemInBatchEmpty ? null : onSave,
              style: IconButton.styleFrom(
                foregroundColor: POSTheme.primaryBlue,
                side: const BorderSide(color: POSTheme.primaryBlue),
              ),
            ),
            const SizedBox(width: 8),
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
          children: [
            Expanded(
              child: FilledButton(
                onPressed: cart.isItemEmpty ? null : onPressed,
                child: Text(label),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
