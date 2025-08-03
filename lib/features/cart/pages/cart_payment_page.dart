import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:objectid/objectid.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
import '../../../data/user/user.model.dart';
import '../../../data/user/user.provider.dart';
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

  void onPay() {
    ref.read(cartStateProvider);
    context.goNamed(IkkiRouter.pos.name);
  }

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
    var change = tendered - net;
    var unpaid = net - tendered;

    if (change < 0) change = 0;
    if (unpaid < 0) unpaid = 0;

    final disablePaymentSelection = unpaid == 0;
    final allowToPay = unpaid <= 0;

    final user = ref.read(currentUserProvider)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.goNamed(IkkiRouter.cart.name),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Pembayaran'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Column(
              children: <Widget>[
                _Summary(
                  net: net,
                  change: change,
                  unpaid: unpaid,
                ),
                const Divider(),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                  net: net,
                  payments: payments,
                  onPaymentsChanged: (p) => setState(() => payments = p),
                  user: user,
                  disablePaymentSelection: disablePaymentSelection,
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
                children: <Widget>[
                  ColoredBox(
                    color: POSTheme.backgroundSecondary,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(cart.rc, style: textTheme.labelMedium),
                          const SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.person, size: 20),
                              const SizedBox(width: 8),
                              Text('Rizqy Nugroho', style: textTheme.labelMedium),
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
                        children: <Widget>[
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
                    onPressed: allowToPay ? onPay : null,
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
    final net = items.fold<double>(0, (prev, curr) => prev + curr.gross);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pesanan ${batch.id}', style: textTheme.titleSmall),
            Text(Formatter.toIdr.format(net), style: textTheme.titleSmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(Formatter.date.format(DateTime.parse(batch.at)), style: textTheme.bodySmall),
        const SizedBox(height: 12),
        for (final item in items) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.qty} x ${item.product.name}',
                  style: textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                Formatter.toIdrNoSymbol.format(item.gross),
                style: textTheme.bodySmall,
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
    required this.net,
    required this.payments,
    required this.onPaymentsChanged,
    required this.user,
    required this.disablePaymentSelection,
  });

  final double net;
  final List<CartPayment> payments;
  final void Function(List<CartPayment>) onPaymentsChanged;
  final UserModel user;
  final bool disablePaymentSelection;

  void onAdd(PaymentModel payment, double amount) {
    onPaymentsChanged([
      ...payments,
      CartPayment(
        amount: amount,
        payment: payment,
        at: DateTime.now().toString(),
        id: ObjectId().hexString,
        by: user.id,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Pilih Metode Pembayaran', style: textTheme.titleSmall),
            if (payments.isNotEmpty) ...[
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8,
                  children: <Widget>[
                    for (final payment in payments)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: POSTheme.borderDark),
                        ),
                        child: Row(
                          children: [
                            Text(
                              payment.payment.type == PaymentType.cash
                                  ? 'Tunai: ${Formatter.toIdr.format(payment.amount)}'
                                  : '${payment.payment.label}: ${Formatter.toIdr.format(payment.amount)}',
                              style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
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
                onSelected: () => onAdd(PaymentModel.cash, net),
              ),
              for (final cash in generateCashRecommendationsIDR(net))
                buildChip(
                  label: Formatter.toIdr.format(cash),
                  onSelected: () => onAdd(PaymentModel.cash, cash),
                ),
              buildChip(
                label: 'Nominal Lain',
                onSelected: () => onAdd(PaymentModel.cash, net),
              ),
            ]),
            const SizedBox(height: 16),
            buildSection(context, 'Non Tunai', <Widget>[
              for (final payment in PaymentModel.data.where((e) => e.type == PaymentType.cashless))
                buildChip(
                  label: payment.label,
                  onSelected: () => onAdd(payment, net),
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
    required VoidCallback? onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      onSelected: disablePaymentSelection ? null : (_) => onSelected!(),
      selected: false,
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
    required this.change,
    required this.unpaid,
  });

  final double net;
  final double change;
  final double unpaid;

  @override
  Widget build(BuildContext context) {
    Widget buildSummary({
      required String label,
      required double amount,
      required Color color,
    }) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              Formatter.toIdr.format(amount),
              style: context.textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
      );
    }

    return ColoredBox(
      color: Colors.white,
      child: IntrinsicHeight(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 96),
          child: Row(
            children: <Widget>[
              buildSummary(label: 'Total Tagihan', amount: net, color: POSTheme.accentGreen),
              const VerticalDivider(),
              buildSummary(label: 'Sisa Tagihan', amount: unpaid, color: POSTheme.accentRed),
              const VerticalDivider(),
              buildSummary(label: 'Kembalian', amount: change, color: POSTheme.accentGreen),
            ],
          ),
        ),
      ),
    );
  }
}
