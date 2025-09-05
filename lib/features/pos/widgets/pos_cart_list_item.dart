import 'package:flutter/material.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_extension.dart';
import '../../../data/cart/cart_model.dart';
import '../../../shared/utils/formatter.dart';

class PosCartListItem extends StatelessWidget {
  const PosCartListItem({required this.isSelected, required this.onTap, required this.cart, super.key});

  final bool isSelected;
  final Cart cart;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderColor = isSelected ? POSTheme.cardBorderFocus : POSTheme.borderLight;
    final backgroundColor = isSelected ? POSTheme.cardBgFocus : Colors.white;

    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                children: [
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
                    children: [
                      Text('-', style: textTheme.labelMedium),
                      Text('Belum Lunas', style: textTheme.labelMedium?.copyWith(color: POSTheme.accentRed)),
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
