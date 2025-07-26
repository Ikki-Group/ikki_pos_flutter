import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pos_theme.dart';
import '../../../data/cart/cart_state.dart';
import '../../../shared/utils/formatter.dart';

class PaymentSummary extends ConsumerWidget {
  const PaymentSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartStateProvider);
    final textTheme = context.textTheme;

    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        height: 90,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total Tagihan', style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(Formatter.toIdr.format(cart.net), style: textTheme.headlineMedium),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sisa Tagihan', style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      Formatter.toIdr.format(cart.net),
                      style: textTheme.headlineMedium?.copyWith(color: POSTheme.errorRedLight),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Kembalian', style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      Formatter.toIdr.format(0),
                      style: textTheme.headlineMedium?.copyWith(color: POSTheme.cashColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
