import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/formatter.dart';
import '../../provider/cart_provider.dart';

class CartSummary extends ConsumerStatefulWidget {
  const CartSummary({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartSummaryState();
}

class _CartSummaryState extends ConsumerState<CartSummary> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final subtotal = ref.watch(cartProvider.select((s) => s.net));
    final itemCount = ref.watch(cartProvider.select((s) => s.items.fold<int>(0, (prev, curr) => prev + curr.qty)));

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
            color: AppTheme.statusWarning.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.secondaryOrangeDark.withValues(alpha: .2)),
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
