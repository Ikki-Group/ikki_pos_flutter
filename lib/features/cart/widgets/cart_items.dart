import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pos_theme.dart';
import '../../../data/cart/cart.model.dart';
import '../../../data/cart/cart.provider.dart';
import '../../../data/product/product.provider.dart';
import '../../../shared/utils/formatter.dart';
import 'cart_product_picker_dialog.dart';

class CartItems extends ConsumerWidget {
  const CartItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartStateProvider.select((s) => s.items));
    final noRecord = items.isEmpty;

    return Expanded(
      child: noRecord
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart_rounded, size: 32, color: POSTheme.primaryBlueDark),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang kosong',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: POSTheme.primaryBlueDark,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _Item(
                  item: item,
                  onRemoved: () => ref.read(cartStateProvider.notifier).removeItem(item),
                  onPressed: () async {
                    final product = await ref
                        .read(productProvider.future)
                        .then((value) => value.products.firstWhere((p) => p.id == item.product.id));

                    await CartProductPickerDialog.show(
                      // ignore: use_build_context_synchronously
                      context,
                      product: product,
                      cartItem: item,
                    );
                  },
                );
              },
            ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.item, required this.onRemoved, required this.onPressed});

  final CartItem item;
  final VoidCallback onRemoved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // color: const Color.fromARGB(137, 240, 240, 240),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${item.qty}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.product.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (item.variant != null && item.variant!.name.isNotEmpty)
                    Text(
                      item.variant!.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  if (item.note.isNotEmpty)
                    Text(
                      item.note,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(Formatter.toIdrNoSymbol.format(item.gross), style: const TextStyle(fontSize: 14)),
            // const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.highlight_off,
                size: 24,
              ),
              style: IconButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding: EdgeInsets.zero,
              ),
              onPressed: onRemoved,
            ),
          ],
        ),
      ),
    );
  }
}
