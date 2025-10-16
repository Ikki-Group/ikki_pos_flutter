import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_constant.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../utils/formatter.dart';
import '../../../cart/model/cart_extension.dart';
import '../../../cart/model/cart_state.dart';
import '../../../sales/provider/sales_provider.dart';
import 'pos_home_notifier.dart';

class PosSales extends ConsumerWidget {
  const PosSales({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final selectedCartId = ref.watch(posFilterProvider.select((value) => value.selectedCartId));

    var salesState = ref.watch(salesProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Daftar Pesanan', style: textTheme.labelLarge),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: salesState.when<Widget>(
                data: (data) {
                  data = data.where((item) => item.status == CartStatus.process).toList();
                  return ListView.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return PosSalesItem(
                        cart: item,
                        onTap: () {
                          ref.read(posFilterProvider.notifier).setSelectedCart(item.id);
                        },
                        isSelected: item.id == selectedCartId,
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                  );
                },
                error: (_, _) => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PosSalesItem extends StatelessWidget {
  const PosSalesItem({required this.isSelected, required this.onTap, required this.cart, super.key});

  final bool isSelected;
  final CartState cart;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderColor = isSelected ? AppTheme.cardBorderFocus : AppTheme.borderLight;
    final backgroundColor = isSelected ? AppTheme.cardBgFocus : Colors.white;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Formatter.dateTime.format(DateTime.parse(cart.createdAt)),
                    style: textTheme.labelMedium,
                  ),
                  Text(
                    cart.rc,
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Divider(color: borderColor),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cart.label, style: textTheme.labelMedium),
                      Text(Formatter.toIdr.format(cart.net), style: textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('-', style: textTheme.labelMedium),
                      Text(
                        'Belum Lunas',
                        style: textTheme.labelMedium?.copyWith(color: AppTheme.accentRed),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
