import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../router/app_router.dart';
import '../../../../widgets/dialogs/sales_mode_dialog.dart';
import '../../provider/cart_provider.dart';
import 'cart_actions.dart';
import 'cart_category.dart';
import 'cart_items.dart';
import 'cart_product_catalog.dart';
import 'cart_search.dart';
import 'cart_summary.dart';

class CartOrderPage extends ConsumerStatefulWidget {
  const CartOrderPage({super.key});

  @override
  ConsumerState<CartOrderPage> createState() => _CartOrderPageState();
}

class _CartOrderPageState extends ConsumerState<CartOrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppTheme.backgroundSecondary,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: <Widget>[
                  _Header(),
                  SizedBox(height: 8),
                  CartCategories(),
                  SizedBox(height: 14),
                  _ProductFilterSection(),
                  SizedBox(height: 16),
                  CartProductCatalog(),
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
                    _SalesModeInfo(),
                    SizedBox(height: 12),
                    CartItems(),
                    SizedBox(height: 12),
                    CartSummary(),
                    SizedBox(height: 12),
                    CartActions(),
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
      context.goNamed(AppRouter.pos.name);
      ref.read(cartProvider.notifier).reset();
    }

    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.home, size: 24, color: AppTheme.textOnSecondary),
          onPressed: onBack,
          style: IconButton.styleFrom(side: const BorderSide(style: BorderStyle.none)),
        ),
        const SizedBox(width: 8),
        const _BadgeReceiptCode(),
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
        const CartSearch(),
        const SizedBox(width: 8),
        TextButton.icon(onPressed: null, icon: const Icon(Icons.add), label: const Text('Custom Amount')),
      ],
    );
  }
}

class _SalesModeInfo extends ConsumerWidget {
  const _SalesModeInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final text = '${cart.salesMode.value} (${cart.pax} Pax)';

    void onPressed() {
      SalesModeDialog.show(context);
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(onPressed: onPressed, child: Text(text)),
    );
  }
}

class _BadgeReceiptCode extends ConsumerWidget {
  const _BadgeReceiptCode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rc = ref.watch(cartProvider.select((s) => s.rc));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: AppTheme.borderLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.receipt, size: 16, color: AppTheme.textOnSecondary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'ID: $rc',
              style: context.textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
