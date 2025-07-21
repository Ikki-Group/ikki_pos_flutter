import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/pos_theme.dart';
import '../../../data/cart/cart.provider.dart';
import '../../../data/product/product.model.dart';
import '../../../data/product/product.provider.dart';
import '../../../router/ikki_router.dart';
import '../../../shared/utils/formatter.dart';
import '../../../widgets/dialogs/sales_mode_dialog.dart';
import '../providers/cart_index_provider.dart';
import '../widgets/cart_product_picker_dialog.dart';

class CartIndexPage extends ConsumerWidget {
  const CartIndexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ColoredBox(
        color: const Color.fromARGB(255, 244, 247, 253),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    const _Header(),
                    const SizedBox(height: 12),
                    const _CategoriesSection(),
                    const SizedBox(height: 12),
                    _ProductFilterSection(),
                    const SizedBox(height: 12),
                    const _ProductSection(),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SalesModeButton(),
                      SizedBox(height: 12),
                      _CartItems(),
                      SizedBox(height: 12),
                      _CartSummary(),
                      SizedBox(height: 12),
                      _CartAction(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rc = ref.watch(cartStateProvider).rc;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.menu, size: 24, color: Colors.grey[600]),
          onPressed: () {
            context.goNamed(IkkiRouter.pos.name);
            ref.read(cartStateProvider.notifier).reset();
          },
        ),
        const SizedBox(width: 8),
        _buildReceiptCode(rc),
        const Spacer(),
        _buildCustomerInfo('name', 'email@email.com'),
      ],
    );
  }

  Widget _buildReceiptCode(String rc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: POSTheme.neutral200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            'Order ID: $rc',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: POSTheme.neutral600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(String name, String email) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.edit, size: 20, color: Colors.grey[600]),
        ],
      ),
    );
  }
}

class _CategoriesSection extends ConsumerWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(productProvider).requireValue.categories;
    final categoryId = ref.watch(cartIndexProvider).categoryId;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories)
            _buildCategoryItem(
              category,
              categoryId == category.id,
              () {
                ref.read(cartIndexProvider.notifier).setCategory(category.id);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(ProductCategory category, bool isSelected, void Function() onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      constraints: const BoxConstraints(minWidth: 120),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          foregroundColor: isSelected ? Colors.white : Colors.grey[800],
          backgroundColor: isSelected ? const Color(0xFF4285F4) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: Colors.grey[200]!),
          fixedSize: Size.infinite,
        ),
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${category.productCount} Items',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductFilterSection extends ConsumerWidget {
  _ProductFilterSection();

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(cartIndexProvider).search;
    print('search: $search');
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: const Size.square(48),
            foregroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(
            Icons.align_horizontal_left_sharp,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(fontSize: 16),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (value) {
              ref.read(cartIndexProvider.notifier).setSearch(value);
            },
            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Cari Produk...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              suffixIcon: _controller.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        _controller.clear();
                        ref.read(cartIndexProvider.notifier).clearSearch();
                      },
                      child: const Icon(Icons.clear, color: Colors.redAccent),
                    )
                  : null,
              constraints: const BoxConstraints(minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            fixedSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text(
            'Custom Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductSection extends ConsumerWidget {
  const _ProductSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(productProvider).requireValue.products;
    final state = ref.watch(cartIndexProvider);
    var products = allProducts;

    if (state.categoryId != ProductCategory.kIdAll) {
      products = allProducts.where((product) => product.categoryId == state.categoryId).toList();
    }

    if (state.search.isNotEmpty) {
      products = products.where((product) => product.name.toLowerCase().contains(state.search.toLowerCase())).toList();
    }

    void onPress(ProductModel product) {
      // ref.read(cartStateProvider.notifier).addProductDirectly(product);
      CartProductPickerDialog.show(
        context,
        product: product,
        onConfirm: (product, quantity, note, variant) {
          print('Product: ${product.name}');
          print('Quantity: $quantity');
          print('Note: $note');
          print('Variant: $variant');
          print('Total: Rp ${(product.price * quantity).toStringAsFixed(0)}');
        },
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 19 / 8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: POSTheme.neutral800,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: const BorderSide(color: POSTheme.neutral200),
            ),
            onPressed: () => onPress(product),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  Formatter.toIdr.format(product.price),
                  style: const TextStyle(fontSize: 14, color: POSTheme.neutral600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SalesModeButton extends ConsumerWidget {
  const _SalesModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartStateProvider);
    final text = '${cart.saleMode.name} (${cart.pax} Pax)';

    void onPressed() {
      SalesModeDialog.show(context);
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(onPressed: onPressed, child: Text(text)),
    );
  }
}

class _CartItems extends ConsumerWidget {
  const _CartItems();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartStateProvider.select((s) => s.items));
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(137, 240, 240, 240),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.qty}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.product.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (item.variant != null && item.variant!.name.isNotEmpty)
                        Text(
                          item.variant!.name,
                          style: TextStyle(
                            fontSize: 16,
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
                const SizedBox(width: 8),
                Text(Formatter.toIdrNoSymbol.format(item.gross)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.highlight_off),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    ref.read(cartStateProvider.notifier).removeItem(item);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CartSummary extends ConsumerStatefulWidget {
  const _CartSummary();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __CartSummaryState();
}

class __CartSummaryState extends ConsumerState<_CartSummary> {
  bool _isDetailExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return InkWell(
      onTap: () {
        setState(() {
          _isDetailExpanded = !_isDetailExpanded;
        });
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: POSTheme.lightOrange.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items', style: textTheme.titleMedium),
                  Text('10', style: textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: textTheme.titleLarge),
                  Text('Rp 10.000', style: textTheme.titleLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartAction extends ConsumerWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            IconButton.outlined(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => ref.read(cartStateProvider.notifier).clearAllItems(),
              style: IconButton.styleFrom(
                foregroundColor: POSTheme.errorRedLight,
                side: const BorderSide(color: POSTheme.errorRedLight),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              icon: const Icon(Icons.save),
              onPressed: () => ref.read(cartStateProvider.notifier).clearAllItems(),
              style: IconButton.styleFrom(
                foregroundColor: POSTheme.primaryBlue,
                side: const BorderSide(color: POSTheme.primaryBlue),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.discount_outlined),
                label: const Text('Discount'),
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                child: const Text('Bayar'),
                onPressed: () {
                  context.goNamed(IkkiRouter.cartPayment.name);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
