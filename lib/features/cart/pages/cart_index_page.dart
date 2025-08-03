import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_extension.dart';
import '../../../data/cart/cart_state.dart';
import '../../../router/ikki_router.dart';
import '../../../shared/utils/formatter.dart';
import '../../pos/provider/pos_provider.dart';
import '../widgets/cart_categories.dart';
import '../widgets/cart_index_widgets.dart';
import '../widgets/cart_items.dart';
import '../widgets/cart_products.dart';

class CartIndexPage extends ConsumerStatefulWidget {
  const CartIndexPage({super.key});

  @override
  ConsumerState<CartIndexPage> createState() => _CartIndexPageState();
}

class _CartIndexPageState extends ConsumerState<CartIndexPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 8),
                  CartCategories(),
                  SizedBox(height: 14),
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
                  children: <Widget>[
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
          style: IconButton.styleFrom(side: const BorderSide(style: BorderStyle.none)),
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
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.align_horizontal_left_sharp),
          style: IconButton.styleFrom(side: const BorderSide(style: BorderStyle.none)),
        ),
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
    if (!cart.isItemEmpty) label += '  |  ${Formatter.toIdr.format(cart.net)}';

    void onPressed() {
      context.goNamed(IkkiRouter.cartPayment.name);
    }

    void onSave() {
      ref.read(cartStateProvider.notifier).save();
      context.goNamed(IkkiRouter.pos.name);
      ref.invalidate(posCartListProvider);
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
