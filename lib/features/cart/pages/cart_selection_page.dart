import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_palette.dart';
import '../../../data/cart/cart_notifier.dart';
import '../../../data/product/product_provider.dart';
import '../../../router/ikki_router.dart';
import '../../../shared/utils/debounce.dart';
import '../../../widgets/dialogs/sales_mode_modal_old.dart';
import '../../../widgets/ui/button_variants.dart';
import '../manager/cart_selection_manager.dart';
import '../widgets/cart_category.dart';
import '../widgets/cart_order_item.dart';
import '../widgets/cart_products.dart';

const int kFlexLeft = 70;
const int kFlexRight = 30;

class CartSelectionPage extends ConsumerStatefulWidget {
  const CartSelectionPage({super.key});

  @override
  ConsumerState createState() => _CartSelectionPageState();
}

class _CartSelectionPageState extends ConsumerState<CartSelectionPage> {
  @override
  void initState() {
    super.initState();
    ref.read(productDataProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    flex: kFlexLeft,
                    child: Row(
                      spacing: 8,
                      children: [
                        const HomeButton(),
                        const GridViewButton(),
                        Expanded(child: SearchProductInput()),
                        const AddCustomAmountButton(),
                      ],
                    ),
                  ),
                  const Expanded(flex: kFlexRight, child: AddCustomerButton()),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 1),
            Expanded(
              child: Row(
                spacing: 8,
                children: [
                  const Expanded(
                    flex: kFlexLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Column(
                        spacing: 12,
                        children: [
                          CartCategory(),
                          Expanded(
                            child: CartProducts(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(color: Colors.grey, width: 1),
                  Expanded(
                    flex: kFlexRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const OrderModeInfo(),
                          const Expanded(child: CartOrderList()),
                          Row(
                            spacing: 4,
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onPressed: () {},
                                  label: const Text('Simpan'),
                                  icon: const Icon(Icons.save),
                                ),
                              ),
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onPressed: () {},
                                  label: const Text('Diskon'),
                                  icon: const Icon(Icons.discount),
                                ),
                              ),
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onPressed: () {},
                                  label: const Text('Batal'),
                                  icon: const Icon(Icons.cancel),
                                ),
                              ),
                            ],
                          ),
                          const PayButton(),
                        ],
                      ),
                    ),
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

class HomeButton extends ConsumerWidget {
  const HomeButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      style: IconButton.styleFrom(
        foregroundColor: Palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        context.goNamed(IkkiRouter.home.name);
      },
      icon: const Icon(Icons.home),
    );
  }
}

class GridViewButton extends ConsumerWidget {
  const GridViewButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      style: IconButton.styleFrom(
        foregroundColor: Palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {},
      icon: const Icon(Icons.view_carousel),
    );
  }
}

class SearchProductInput extends ConsumerWidget {
  SearchProductInput({super.key});
  final _debouncer = Debouncer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (v) {
        _debouncer.debounce(
          onDebounce: () => ref.read(cartSelectionManagerProvider.notifier).setSearch(v),
        );
      },
      decoration: InputDecoration(
        hintText: 'Cari Produk',
        constraints: const BoxConstraints(maxHeight: 40),
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey[600],
          size: 18,
        ),
        prefixIconConstraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
    );
  }
}

class AddCustomAmountButton extends ConsumerWidget {
  const AddCustomAmountButton({super.key});

  ({int pax, String saleMode, bool test}) test() {
    return (pax: 1, saleMode: 'test', test: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemedButton(
      onPressed: () {},
      size: ButtonSize.large,
      icon: const Icon(Icons.add),
      text: const Text('Custom Amount'),
      variant: ButtonVariant.ghost,
    );
  }
}

class AddCustomerButton extends ConsumerWidget {
  const AddCustomerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: ThemedButton(
        size: ButtonSize.large,
        variant: ButtonVariant.outline,
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        text: const Text('Pelanggan'),
      ),
    );
  }
}

class OrderModeInfo extends ConsumerWidget {
  const OrderModeInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);
    final buttonText = '${cart.saleMode.name} (${cart.pax} Pax)';

    return ThemedButton(
      size: ButtonSize.large,
      onPressed: () {
        SalesModeModal.show(context);
      },
      text: Text(buttonText),
    );
  }
}

class PayButton extends ConsumerWidget {
  const PayButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        fixedSize: const Size.fromWidth(double.infinity),
      ),
      onPressed: () {},
      child: const Text('Bayar  |  Rp. 10.000'),
    );
  }
}
