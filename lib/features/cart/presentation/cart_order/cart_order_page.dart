import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../router/ikki_router.dart';
import '../../../../shared/utils/formatter.dart';
import '../../../../widgets/dialogs/sales_mode_dialog.dart';
import '../../provider/cart_extension.dart';
import '../../provider/cart_provider.dart';
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
                children: [
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
      // ref.read(cartStateProvider.notifier).reset();
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

class _CartAction extends ConsumerWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final isEmpty = cart.currentItems.isEmpty;

    var label = 'Bayar';
    if (cart.items.isNotEmpty) label += '  |  ${Formatter.toIdr.format(cart.net)}';

    void onPressed() {
      context.goNamed(IkkiRouter.cartPayment.name);
    }

    // TODO
    Future<void> onSave() async {
      // CartSaveDialog.show(context);
      // await ref.read(cartStateProvider.notifier).save();
      // ref.invalidate(posCartListProvider);
      // if (context.mounted) context.goNamed(IkkiRouter.pos.name);
    }

    Future<void> onClear() async {
      await ref.read(cartProvider.notifier).clearCurrentItems();
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: isEmpty ? null : onClear,
              style: IconButton.styleFrom(
                foregroundColor: AppTheme.accentRed,
                side: const BorderSide(color: AppTheme.accentRed),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              icon: const Icon(Icons.save),
              onPressed: isEmpty ? null : onSave,
              style: IconButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: const BorderSide(color: AppTheme.primaryBlue),
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
        // mainAxisSize: MainAxisSize.min,
        children: [
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
