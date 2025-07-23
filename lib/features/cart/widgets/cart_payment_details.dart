import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/payment/payment.enum.dart';

class CartPaymentDetails extends ConsumerStatefulWidget {
  const CartPaymentDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPaymentDetailsState();
}

class _CartPaymentDetailsState extends ConsumerState<CartPaymentDetails> {
  PaymentMode selectedMode = PaymentMode.cash;
  List<String> payments = <String>[];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _PaymentModeTabs(selectedMode, (mode) {
              selectedMode = mode;
              setState(() {});
            }),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PaymentSelected(payments, (payment) {
                  payments.remove(payment);
                  setState(() {});
                }),
                _ModeDetails(selectedMode, (payment) {
                  payments.add(payment);
                  setState(() {});
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentModeTabs extends StatelessWidget {
  const _PaymentModeTabs(this.selected, this.onPressed);

  final PaymentMode selected;
  final void Function(PaymentMode mode) onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(62, 202, 202, 202),
          ),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.payments,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Metode Pembayaran',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final mode in PaymentMode.values)
                  _buildTab(
                    mode,
                    () => onPressed(mode),
                    selected == mode,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(PaymentMode mode, void Function() onPressed, bool isSelected) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: const WidgetStateProperty<EdgeInsetsGeometry>.fromMap({
          WidgetState.any: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        }),
        shape: const WidgetStateProperty<OutlinedBorder>.fromMap({
          WidgetState.any: RoundedRectangleBorder(),
        }),
        alignment: Alignment.centerLeft,
        foregroundColor: WidgetStateColor.fromMap({WidgetState.any: isSelected ? Colors.blueAccent : Colors.black}),
        backgroundColor: WidgetStateColor.fromMap({
          WidgetState.any: isSelected ? Colors.blueAccent.withValues(alpha: .2) : Colors.transparent,
        }),
        fixedSize: const WidgetStateProperty<Size>.fromMap({WidgetState.any: Size.infinite}),
        textStyle: const WidgetStateTextStyle.fromMap({
          WidgetState.any: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        }),
      ),
      child: Text(mode.label),
    );
  }
}

const _kCashTemplates = <String>['Rp. 10.000', 'Rp. 20.000', 'Rp. 30.000', 'Nominal Lain'];

class _ModeDetails extends ConsumerWidget {
  const _ModeDetails(this.selectedMode, this.onSelect);

  final PaymentMode selectedMode;
  final void Function(String payment) onSelect;

  // void onCustomInput() {
  //   showDialog(context: context, builder: builder)
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final template in _kCashTemplates)
            ChoiceChip(
              label: Text(template),
              showCheckmark: false,
              onSelected: (selected) {
                onSelect('Cash: $template');
              },
              selected: false,
            ),
        ],
      ),
    );
  }
}

class _PaymentSelected extends ConsumerWidget {
  const _PaymentSelected(this.payments, this.onRemoved);

  final List<String> payments;
  final void Function(String payment) onRemoved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (payments.isEmpty) const Text('Pilih Pembayaran', style: TextStyle(fontSize: 14)),
            if (payments.isNotEmpty) ...[
              for (final payment in payments)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(payment, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => onRemoved(payment),
                        child: const Icon(Icons.highlight_off, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
