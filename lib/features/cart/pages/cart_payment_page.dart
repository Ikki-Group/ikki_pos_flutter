import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../router/ikki_router.dart';
import '../widgets/cart_payment_details.dart';
import '../widgets/cart_payment_widgets.dart';

class CartPaymentPage extends ConsumerStatefulWidget {
  const CartPaymentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends ConsumerState<CartPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.goNamed(IkkiRouter.cart.name),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Pembayaran', style: TextStyle(fontSize: 18)),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            flex: 7,
            child: Column(
              children: [
                PaymentSummary(),
                Divider(),
                CartPaymentDetails(),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(child: Placeholder()),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    fixedSize: const Size.fromHeight(64),
                  ),
                  onPressed: () {},
                  child: const Text('Proses Pembayaran'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
