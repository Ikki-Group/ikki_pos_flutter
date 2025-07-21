import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/pos_theme.dart';
import '../../../router/ikki_router.dart';

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
        title: const Text('Pembayaran'),
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              children: [
                _CartPaymentSummary(),
                Divider(),
                _PaymentDetails(),
                // Expanded(
                //   child: Row(
                //     children: <Widget>[
                //       const _PaymentMethodNavigation(),
                //       const VerticalDivider(),
                //       Flexible(
                //         child: Padding(
                //           padding: const EdgeInsets.all(16),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: <Widget>[
                //               Text('Pembayaran', style: context.textTheme.headlineSmall),
                //               const SizedBox(height: 16),
                //               SingleChildScrollView(
                //                 scrollDirection: Axis.horizontal,
                //                 child: Row(
                //                   children: [
                //                     for (var i = 0; i < 10; i++) const _PaymentSelected(),
                //                   ],
                //                 ),
                //               ),
                //               const SizedBox(height: 16),
                //               const _PaymentMethodDetailsOptions(),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 4,
            child: Column(
              children: [Placeholder()],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartPaymentSummary extends ConsumerWidget {
  const _CartPaymentSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    Text('Total', style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text('Rp. 10.000', style: textTheme.headlineMedium),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Balance', style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text('Rp. 10.000', style: textTheme.headlineMedium),
                  ],
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Paid', style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text('Rp. 10.000', style: textTheme.headlineMedium),
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

class _PaymentDetails extends ConsumerStatefulWidget {
  const _PaymentDetails();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __PaymentDetailsState();
}

const List<String> kMethods = <String>['Tunai', 'Transfer Bank', 'QRIS', 'Lainnya'];
const List<String> kCashTemplates = <String>['Rp. 10.000', 'Rp. 20.000', 'Rp. 30.000', 'Nominal Lain'];

class __PaymentDetailsState extends ConsumerState<_PaymentDetails> {
  late String selected;
  List<String> templates = <String>[];

  @override
  void initState() {
    super.initState();
    selected = kMethods[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Metode Pembayaran',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final method in kMethods)
                            _buildTab(method, () {
                              selected = method;
                              setState(() {});
                            }, selected == method),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: templates.map((temp) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(temp),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  templates.remove(temp);
                                  setState(() {});
                                },
                                child: const Icon(Icons.highlight_off, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (templates.isNotEmpty) const SizedBox(height: 16),
                  Text('Tunai', style: context.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kCashTemplates.map((temp) {
                      return ChoiceChip(
                        label: Text(temp),
                        showCheckmark: false,
                        onSelected: (selected) {
                          templates.add(temp);
                          setState(() {});
                        },
                        selected: false,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, void Function() onPressed, bool isSelected) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
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
      child: Text(label),
    );
  }
}

class _PaymentMethodDetailsOptions extends ConsumerWidget {
  const _PaymentMethodDetailsOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = <String>['Rp. 10.000', 'Rp. 20.000', 'Rp. 30.000', 'Nominal Lain'];

    return Expanded(
      child: Wrap(
        spacing: 16,
        children: [
          for (final option in options)
            _PaymentChip(
              label: option,
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

class _PaymentChip extends ConsumerWidget {
  const _PaymentChip({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: POSTheme.neutral400),
        foregroundColor: POSTheme.neutral900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size.zero,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(label),
    );
  }
}

class _PaymentSelected extends ConsumerWidget {
  const _PaymentSelected({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange[700]!,
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Rp.10000',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.highlight_off,
              color: POSTheme.errorRedLight,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
