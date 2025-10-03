import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../router/ikki_router.dart';
import '../../../../shared/utils/formatter.dart';
import '../../model/cart_extension.dart';
import '../../provider/cart_provider.dart';

class CartPaymentSuccessPage extends ConsumerStatefulWidget {
  const CartPaymentSuccessPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPaymentSuccessPageState();
}

class _CartPaymentSuccessPageState extends ConsumerState<CartPaymentSuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  void onDone() {
    context.goNamed(IkkiRouter.pos.name);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cart = ref.watch(cartProvider);

    final change = cart.payments.reversed
        .firstWhereOrNull(
          (p) => p.change != null && p.type == PaymentType.cash,
        )
        ?.change;

    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Icon(
                  Icons.check_circle_outlined,
                  size: 80,
                  color: AppTheme.statusSuccess,
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
                    Text('${cart.itemsCount} Item', style: textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Tagihan', style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    Text(
                      cart.net.toIdr,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final payment in cart.payments)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(payment.label, style: textTheme.bodyMedium),
                      const SizedBox(width: 16),
                      Text(
                        payment.amount.toIdr,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                if (change != null && change > 0) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Kembalian',
                        style: textTheme.titleSmall?.copyWith(color: AppTheme.secondaryOrange),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        change.toIdr,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppTheme.secondaryOrange,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // ref.read(cartProvider.notifier).print();
                    },
                    child: const Text('Cetak Nota'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDone,
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
