import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_state.dart';
import '../../../shared/utils/formatter.dart';
import '../../../widgets/dialogs/sales_mode_dialog.dart';
import '../providers/cart_index_provider.dart';

class BadgeReceiptCode extends ConsumerWidget {
  const BadgeReceiptCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rc = ref.watch(cartStateProvider.select((s) => s.rc));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: POSTheme.borderLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: POSTheme.borderDark),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt, size: 16, color: POSTheme.textOnSecondary),
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

class CustomerInfo extends ConsumerWidget {
  const CustomerInfo({required this.name, required this.email, super.key});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.edit, size: 20, color: Colors.grey[600]),
        ],
      ),
    );
  }
}

class CartSearchProduct extends ConsumerStatefulWidget {
  const CartSearchProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartSearchProductState();
}

class _CartSearchProductState extends ConsumerState<CartSearchProduct> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(cartIndexProvider.select((s) => s.search));

    void onChanged(String value) {
      ref.read(cartIndexProvider.notifier).setSearch(value);
    }

    void onClear() {
      _controller.clear();
      ref.read(cartIndexProvider.notifier).clearSearch();
    }

    return Expanded(
      child: TextField(
        controller: _controller,
        autocorrect: false,
        enableSuggestions: false,
        style: const TextStyle(fontSize: 14),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Cari Produk...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: search.isNotEmpty
              ? InkWell(
                  onTap: onClear,
                  child: const Icon(Icons.highlight_off, color: POSTheme.accentRed),
                )
              : null,
          constraints: const BoxConstraints(minHeight: 48),
        ),
      ),
    );
  }
}

class CartSalesModeInfo extends ConsumerWidget {
  const CartSalesModeInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartStateProvider);
    final text = '${cart.saleMode.value} (${cart.pax} Pax)';

    void onPressed() {
      SalesModeDialog.show(context);
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(onPressed: onPressed, child: Text(text)),
    );
  }
}

class CartSummaryExpanded extends ConsumerStatefulWidget {
  const CartSummaryExpanded({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartSummaryExpandedState();
}

class _CartSummaryExpandedState extends ConsumerState<CartSummaryExpanded> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final subtotal = ref.watch(cartStateProvider.select((s) => s.net));
    final itemCount = ref.watch(cartStateProvider.select((s) => s.items.fold<int>(0, (prev, curr) => prev + curr.qty)));

    return InkWell(
      onTap: () {
        _isExpanded = !_isExpanded;
        setState(() {});
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: POSTheme.statusWarning.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: POSTheme.secondaryOrangeDark.withValues(alpha: .2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items', style: textTheme.labelMedium),
                  Text('$itemCount item', style: textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: textTheme.labelLarge),
                  Text(Formatter.toIdr.format(subtotal), style: textTheme.labelLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
