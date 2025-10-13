import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../router/app_router.dart';
import '../../../../utils/cash_generator.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/formatter.dart';
import '../../../auth/provider/user_provider.dart';
import '../../../outlet/provider/outlet_provider.dart';
import '../../../sales/model/payment_model.dart';
import '../../model/cart_extension.dart';
import '../../model/cart_state.dart';
import '../../provider/cart_provider.dart';
import 'cart_payment_notifier.dart';

class CartPaymentPage extends ConsumerStatefulWidget {
  const CartPaymentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPaymentPageState();
}

class _CartPaymentPageState extends ConsumerState<CartPaymentPage> {
  void onPay() {
    context.goNamed(AppRouter.cartPaymentSuccess.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.goNamed(AppRouter.cart.name),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Pembayaran'),
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Column(
              children: <Widget>[
                _Summary(),
                Divider(),
                _Actions(),
                Divider(),
                _CartPaymentMethod(),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 4,
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _OrderInfo(),
                  Divider(),
                  _OrderItemsPreview(),
                  _PayButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartPaymentMethod extends ConsumerWidget {
  const _CartPaymentMethod();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(cartPaymentNotifier);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Pilih Metode Pembayaran', style: textTheme.titleSmall),
              if (state.payments.isNotEmpty) ...[
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: <Widget>[
                      for (final payment in state.payments)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderDark),
                          ),
                          child: Row(
                            children: [
                              Text(
                                payment.formattedLabel,
                                style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  ref.read(cartPaymentNotifier.notifier).removePayment(payment.id);
                                },
                                child: const Icon(Icons.highlight_off, color: AppTheme.accentRed, size: 24),
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
                  'Uang Pas',
                  disabled: state.allowToPay,
                  onSelected: () => ref.read(cartPaymentNotifier.notifier).addPayment(PaymentModel.cash, state.total),
                ),
                for (final cash in CashPaymentGenerator.generateCashOptions(state.total.toInt()))
                  buildChip(
                    Formatter.toIdr.format(cash),
                    disabled: state.allowToPay,
                    onSelected: () =>
                        ref.read(cartPaymentNotifier.notifier).addPayment(PaymentModel.cash, cash.toDouble()),
                  ),
                buildChip(
                  'Nominal Lain',
                  disabled: state.allowToPay,
                  // onSelected: () => CartCashCustom.show(context),
                  onSelected: () {},
                ),
              ]),
              const SizedBox(height: 16),
              buildSection(context, 'Non Tunai', <Widget>[
                for (final payment in PaymentModel.data.where((e) => e.type == PaymentType.cashless))
                  buildChip(
                    payment.label,
                    disabled: state.allowToPay,
                    onSelected: () => ref.read(cartPaymentNotifier.notifier).addPayment(payment, state.total),
                  ),
              ]),
            ],
          ),
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
          runSpacing: 8,
          children: child,
        ),
      ],
    );
  }

  Widget buildChip(
    String label, {
    required bool disabled,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      showCheckmark: false,
      onSelected: disabled ? null : (_) => onSelected(),
      selected: false,
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartPaymentNotifier);
    final textTheme = Theme.of(context).textTheme;

    Widget buildSummary(String label, double amount, Color color) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(Formatter.toIdr.format(amount), style: textTheme.titleMedium?.copyWith(color: color)),
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
              buildSummary('Total Tagihan', state.total, AppTheme.accentGreen),
              const VerticalDivider(),
              buildSummary('Sisa Tagihan', state.remaining, AppTheme.accentRed),
              const VerticalDivider(),
              buildSummary('Kembalian', state.change, AppTheme.accentGreen),
            ],
          ),
        ),
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FilledButton(
              onPressed: null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                shape: const RoundedRectangleBorder(),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // side: BorderSide(color: AppTheme.),
              ),
              child: const Text('Pisah Bayar'),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: FilledButton(
              // onPressed: () => CartNoteDialog.show(context),
              onPressed: null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                shape: const RoundedRectangleBorder(),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // side: BorderSide(color: AppTheme.),
              ),
              child: const Text('Catatan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderInfo extends ConsumerWidget {
  const _OrderInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final cart = ref.watch(cartProvider);
    return ColoredBox(
      color: AppTheme.backgroundSecondary,
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
    );
  }
}

class _OrderItemsPreview extends ConsumerWidget {
  const _OrderItemsPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    Widget buildItemBatch(List<CartItem> items, CartBatch batch) {
      final textTheme = Theme.of(context).textTheme;
      final net = items.fold<double>(0, (prev, curr) => prev + curr.gross);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan ${batch.id}', style: textTheme.titleMedium),
              Text(net.toIdr, style: textTheme.titleMedium),
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
                  item.gross.toIdrNoSymbol,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Expanded(
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
    );
  }
}

class _PayButton extends ConsumerWidget {
  const _PayButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payState = ref.watch(cartPaymentNotifier);

    Future<void> pay() async {
      final outlet = ref.read(outletProvider);
      final user = ref.read(userProvider).selectedUser;
      await ref.read(cartProvider.notifier).pay(payState.payments, user, outlet);
      if (!context.mounted) return;
      context
        ..showTextSnackBar("Berhasil menyelesaikan penjualan")
        ..goNamed(AppRouter.cartPaymentSuccess.name);
    }

    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        fixedSize: const Size.fromHeight(64),
      ),
      onPressed: payState.allowToPay ? pay : null,
      child: const Text('Proses Pembayaran'),
    );
  }
}
