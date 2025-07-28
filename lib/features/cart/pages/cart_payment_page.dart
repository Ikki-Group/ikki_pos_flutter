import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:objectid/objectid.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
import '../../../router/ikki_router.dart';
import '../../../shared/utils/formatter.dart';
import '../../payment/payment_enum.dart';
import '../../payment/payment_model.dart';

class CartPaymentPage extends ConsumerStatefulWidget {
  const CartPaymentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends ConsumerState<CartPaymentPage> {
  late Cart cart;
  late double net;

  List<CartPayment> payments = [];

  @override
  void initState() {
    super.initState();
    cart = ref.read(cartStateProvider);
    net = cart.net;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final tendered = payments.fold<double>(0, (prev, curr) => prev + curr.amount);
    final change = tendered - net;

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
          Expanded(
            flex: 7,
            child: Column(
              children: [
                _Summary(
                  net: net,
                  payments: payments,
                ),
                const Divider(),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: POSTheme.backgroundSecondary,
                            elevation: 0,
                            foregroundColor: POSTheme.textPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: const RoundedRectangleBorder(),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // side: BorderSide(color: POSTheme.),
                          ),
                          child: const Text('Pisah Bayar'),
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: POSTheme.backgroundSecondary,
                            foregroundColor: POSTheme.textPrimary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: const RoundedRectangleBorder(),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            // side: BorderSide(color: POSTheme.),
                          ),
                          child: const Text('Catatan'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                _CartPaymentMethod(
                  cart: cart,
                  payments: payments,
                  onPaymentsChanged: (p) => setState(() => payments = p),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 4,
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColoredBox(
                    color: POSTheme.backgroundSecondary,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(cart.rc, style: textTheme.titleSmall),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text('Rizqy Nugroho', style: textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (final batch in cart.batches) ...[
                            buildItemBatch(cart.items.where((item) => item.batchId == batch.id).toList(), batch),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget buildItemBatch(List<CartItem> items, CartBatch batch) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pesanan ${batch.id}', style: textTheme.labelLarge),
            Text(Formatter.date.format(DateTime.parse(batch.at)), style: textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in items) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.qty} x ${item.product.name}',
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                Formatter.toIdrNoSymbol.format(item.gross),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

final kCashIDR = <double>[5000, 10000, 20000, 50000, 100000];
final kCashless = <String>['BCA', 'Mandiri', 'QRIS'];

class _CartPaymentMethod extends StatelessWidget {
  const _CartPaymentMethod({
    required this.cart,
    required this.payments,
    required this.onPaymentsChanged,
  });

  final Cart cart;
  final List<CartPayment> payments;
  final void Function(List<CartPayment>) onPaymentsChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Pilih Metode Pembayaran', style: textTheme.titleMedium),
            if (payments.isNotEmpty) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: [
                    for (final payment in payments)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: POSTheme.borderLight),
                        ),
                        child: Row(
                          children: [
                            Text(
                              payment.payment.type == PaymentType.cash
                                  ? 'Tunai: ${Formatter.toIdr.format(payment.amount)}'
                                  : '${payment.payment.label}: ${Formatter.toIdr.format(payment.amount)}',
                              style: textTheme.labelLarge,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                onPaymentsChanged(payments.where((p) => p.id != payment.id).toList());
                              },
                              child: const Icon(Icons.highlight_off, color: POSTheme.accentRed, size: 24),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            buildSection(context, 'Tunai', <Widget>[
              buildChip(
                label: 'Uang Pas',
                selected: false,
                onSelected: () {
                  onPaymentsChanged([
                    ...payments,
                    CartPayment(
                      amount: cart.net,
                      payment: PaymentModel.cash,
                      at: DateTime.now().toString(),
                      by: 'Rizqy Nugroho',
                      id: ObjectId().hexString,
                    ),
                  ]);
                },
              ),
              for (final cash in generateCashRecommendationsIDR(cart.net))
                buildChip(
                  label: Formatter.toIdr.format(cash),
                  selected: false,
                  onSelected: () {
                    onPaymentsChanged([
                      ...payments,
                      CartPayment(
                        amount: cash,
                        payment: PaymentModel.cash,
                        at: DateTime.now().toString(),
                        by: 'Rizqy Nugroho',
                        id: ObjectId().hexString,
                      ),
                    ]);
                  },
                ),
              buildChip(
                label: 'Nominal Lain',
                selected: false,
                onSelected: () {
                  onPaymentsChanged([
                    ...payments,
                    CartPayment(
                      amount: cart.net,
                      payment: PaymentModel.cash,
                      at: DateTime.now().toString(),
                      by: 'Rizqy Nugroho',
                      id: ObjectId().hexString,
                    ),
                  ]);
                },
              ),
            ]),
            const SizedBox(height: 16),
            buildSection(context, 'Non Tunai', <Widget>[
              for (final payment in PaymentModel.data.where((e) => e.type == PaymentType.cashless))
                buildChip(
                  label: payment.label,
                  selected: false,
                  onSelected: () {
                    onPaymentsChanged([
                      ...payments,
                      CartPayment(
                        amount: cart.net,
                        payment: payment,
                        at: DateTime.now().toString(),
                        by: 'Rizqy Nugroho',
                        id: ObjectId().hexString,
                      ),
                    ]);
                  },
                ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildSection(BuildContext context, String title, List<Widget> child) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: child,
        ),
      ],
    );
  }

  Widget buildChip({
    required String label,
    required bool selected,
    required VoidCallback? onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      onSelected: onSelected != null ? (_) => onSelected() : null,
      selected: selected,
      backgroundColor: selected ? POSTheme.primaryBlue : Colors.white,
    );
  }

  List<double> generateCashRecommendationsIDR(double total) {
    final cashRecommendations = <double>[];
    for (final cash in kCashIDR) {
      if (cash >= total) {
        cashRecommendations.add(cash);
      }
    }
    return cashRecommendations;
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.net,
    required this.payments,
  });

  final double net;
  final List<CartPayment> payments;

  @override
  Widget build(BuildContext context) {
    final paid = payments.fold<double>(0, (prev, curr) => prev + curr.amount);

    var unpaid = net - paid;
    if (unpaid < 0) unpaid = 0;

    var change = paid - net;
    if (change < 0) change = 0;

    return ColoredBox(
      color: Colors.white,
      child: IntrinsicHeight(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 96),
          child: Row(
            children: <Widget>[
              buildSummary(context, label: 'Total Tagihan', amount: net, color: POSTheme.accentGreen),
              const VerticalDivider(),
              buildSummary(context, label: 'Sisa Tagihan', amount: unpaid, color: POSTheme.accentRed),
              const VerticalDivider(),
              buildSummary(context, label: 'Kembalian', amount: change, color: POSTheme.accentGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSummary(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: context.textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(
            Formatter.toIdr.format(amount),
            style: context.textTheme.titleLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
