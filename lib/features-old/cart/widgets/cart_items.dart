import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
import '../../../data/product/product.model.dart';
import '../../../data/product/product.provider.dart';
import '../../../shared/utils/formatter.dart';
import '../../../widgets/dialogs/cart_product_picker_dialog.dart';

class CartItems extends ConsumerWidget {
  const CartItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartStateProvider.select((s) => s.items));
    final noRecord = items.isEmpty;

    void openPicker(ProductModel product, CartItem cartItem) {
      CartProductPickerDialog.show(
        context,
        product: product,
        cartItem: cartItem,
      );
    }

    return Expanded(
      child: noRecord
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_shopping_cart_rounded, size: 32, color: POSTheme.primaryBlueDark),
                  SizedBox(height: 16),
                  Text(
                    'Tambahkan item',
                    style: TextStyle(
                      fontSize: 14,
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
                    await ref
                        .read(productProvider.future)
                        .then((value) => value.products.firstWhere((p) => p.id == item.product.id))
                        .then((value) => openPicker(value, item));
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
          color: POSTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
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
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    if (item.variant != null && item.variant!.name.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.variant!.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                    if (item.note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Note: ${item.note}',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 32,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    Formatter.toIdrNoSymbol.format(item.gross),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: -.25),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              InkWell(
                onTap: onRemoved,
                child: const SizedBox.square(
                  dimension: 32,
                  child: Icon(
                    Icons.highlight_off,
                    size: 24,
                    color: POSTheme.accentRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
