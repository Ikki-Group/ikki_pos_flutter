import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/pos_theme.dart';
import '../../../data/cart/cart.provider.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: const ColoredBox(
        color: Color.fromARGB(255, 244, 247, 253),
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
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu, size: 24, color: Colors.grey[600]),
          onPressed: () {
            context.goNamed(IkkiRouter.pos.name);
            ref.read(cartStateProvider.notifier).reset();
          },
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
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: const Size.square(48),
            foregroundColor: POSTheme.primaryBlueDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(
            Icons.align_horizontal_left_sharp,
          ),
        ),
        const SizedBox(width: 8),
        const CartSearchProduct(),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text(
            'Custom Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CartAction extends ConsumerWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(cartStateProvider.select((s) => s.net));
    final hasFilled = subtotal > 0;

    var label = 'Bayar';
    if (hasFilled) label += '  |  ${Formatter.toIdr.format(subtotal)}';

    void onPressed() {
      context.goNamed(IkkiRouter.cartPayment.name);
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => ref.read(cartStateProvider.notifier).clearAllItems(),
              style: IconButton.styleFrom(
                foregroundColor: POSTheme.errorRedLight,
                side: const BorderSide(color: POSTheme.errorRedLight),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              icon: const Icon(Icons.save),
              onPressed: () => ref.read(cartStateProvider.notifier).save(),
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
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: hasFilled ? onPressed : null,
                child: Text(label),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
