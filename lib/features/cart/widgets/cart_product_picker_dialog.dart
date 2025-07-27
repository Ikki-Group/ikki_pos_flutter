import 'package:bson/bson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../../../data/cart/cart_model.dart';
import '../../../data/cart/cart_state.dart';
import '../../../data/product/product.model.dart';
import '../../../shared/utils/formatter.dart';
import '../../../widgets/ui/button_variants.dart';
import '../../../widgets/ui/pos_dialog.dart';

class CartProductPickerDialog extends ConsumerStatefulWidget {
  const CartProductPickerDialog({
    required this.product,
    super.key,
    this.cartItem,
  });

  final ProductModel product;
  final CartItem? cartItem;

  @override
  ConsumerState<CartProductPickerDialog> createState() => CartProductPickerDialogState();

  static Future<void> show(
    BuildContext context, {
    required ProductModel product,
    CartItem? cartItem,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CartProductPickerDialog(
        product: product,
        cartItem: cartItem,
      ),
    );
  }
}

class CartProductPickerDialogState extends ConsumerState<CartProductPickerDialog> {
  int quantity = 1;
  String? selectedVariant;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItem?.qty ?? 1;
    selectedVariant = widget.cartItem?.variant?.id;
    noteController = TextEditingController()..text = widget.cartItem?.note ?? '';
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    quantity = quantity >= 99 ? 99 : quantity + 1;
    setState(() {});
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      quantity--;
      setState(() {});
    }
  }

  void _onConfirm() {
    final cart = ref.read(cartStateProvider.notifier);

    CartItemVariant? variant;

    if (selectedVariant != null) {
      final rawVariant = widget.product.variants.firstWhere((v) => v.id == selectedVariant);
      variant = CartItemVariant(
        id: rawVariant.id,
        name: rawVariant.name,
        price: rawVariant.price,
      );
    }

    final price = variant?.price ?? widget.product.price;
    cart.addCartItem(
      CartItem(
        id: widget.cartItem?.id ?? ObjectId().toString(),
        batchId: 1,
        product: CartItemProduct(
          id: widget.product.id,
          name: widget.product.name,
          price: widget.product.price,
        ),
        variant: variant,
        qty: quantity,
        price: price,
        note: noteController.text,
        gross: price * quantity,
        net: price * quantity,
      ),
    );

    Navigator.of(context).pop();
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    var allowToProcess = quantity > 0;
    if (allowToProcess && widget.product.hasVariant) {
      allowToProcess = selectedVariant != null;
    }

    return PosDialog(
      title: widget.product.name,
      constraints: const BoxConstraints(maxWidth: 700),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: textTheme.titleMedium),
                  Text(
                    Formatter.toIdr.format(widget.product.price * quantity),
                    style: textTheme.titleMedium?.copyWith(color: POSTheme.primaryBlue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(child: ThemedButton.cancel(onPressed: _onClose)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ThemedButton.process(onPressed: allowToProcess ? _onConfirm : null),
          ),
        ],
      ),
      children: [
        Text('Kuantitas', style: textTheme.labelLarge),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: POSTheme.borderLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuantityButton(
                  icon: Icons.remove,
                  onPressed: _decrementQuantity,
                  enabled: quantity > 1,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  constraints: const BoxConstraints(minWidth: 46),
                  alignment: Alignment.center,
                  color: POSTheme.borderLight,
                  child: Text(quantity.toString(), style: textTheme.labelLarge),
                ),
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: _incrementQuantity,
                  enabled: quantity < 99,
                ),
              ],
            ),
          ),
        ),

        // Variants Section (if available)
        if (widget.product.hasVariant && widget.product.variants.isNotEmpty == true) ...[
          const SizedBox(height: 24),
          Text('Varian', style: textTheme.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.product.variants.map((variant) {
              final isSelected = selectedVariant == variant.id;
              return InkWell(
                onTap: () {
                  selectedVariant = variant.id;
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  constraints: const BoxConstraints(minWidth: 160),
                  decoration: BoxDecoration(
                    color: isSelected ? POSTheme.primaryBlue : Colors.white,
                    border: Border.all(
                      color: isSelected ? POSTheme.primaryBlue : const Color(0xFFE5E7EB),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        variant.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatter.toIdr.format(variant.price),
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        // Notes Section
        const SizedBox(height: 24),
        Text('Catatan (Opsional)', style: textTheme.labelLarge),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: noteController,
            maxLines: 3,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText: 'Tambah Catatan...',
              hintStyle: TextStyle(fontSize: 14),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Icon(
          icon,
          color: enabled ? POSTheme.primaryBlueDark : const Color(0xFF9CA3AF),
          size: 20,
        ),
      ),
    );
  }
}
