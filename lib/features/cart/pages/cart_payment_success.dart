import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
import '../../../shared/utils/formatter.dart';

class CartPaymentSuccess extends ConsumerStatefulWidget {
  const CartPaymentSuccess({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPaymentSuccessState();
}

class _CartPaymentSuccessState extends ConsumerState<CartPaymentSuccess> {
  late Cart cart;

  @override
  void initState() {
    super.initState();
    cart = ref.read(cartStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle_outlined,
                  size: 80,
                  color: POSTheme.statusSuccess,
                ),
                const SizedBox(height: 24),
                Text('Pembayaran Berhasil', style: textTheme.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(cart.rc, style: textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jumlah Item', style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    Text('10 Item', style: textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Tagihan', style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    Text(
                      Formatter.toIdr.format(cart.net),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tunai', style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    Text(
                      Formatter.toIdr.format(cart.net),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kembalian', style: textTheme.titleSmall?.copyWith(color: POSTheme.secondaryOrange)),
                    const SizedBox(width: 16),
                    Text(
                      Formatter.toIdr.format(cart.net),
                      style: textTheme.titleSmall?.copyWith(color: POSTheme.secondaryOrange),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Cetak Nota'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Selesai'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
