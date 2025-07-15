import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/core/config/app_palette.dart';
import 'package:ikki_pos_flutter/data/cart/cart_notifier.dart';
import 'package:ikki_pos_flutter/data/product/product_model.dart';
import 'package:ikki_pos_flutter/data/product/product_provider.dart';
import 'package:ikki_pos_flutter/features/cart/manager/cart_selection_manager.dart';
import 'package:ikki_pos_flutter/features/cart/widgets/category_selection.dart';
import 'package:ikki_pos_flutter/router/ikki_router.dart';
import 'package:ikki_pos_flutter/shared/utils/debounce.dart';
import 'package:ikki_pos_flutter/shared/utils/formatter.dart';
import 'package:ikki_pos_flutter/widgets/dialogs/sales_mode_modal.dart';
import 'package:ikki_pos_flutter/widgets/ui/button_variants.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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
                        HomeButton(),
                        GridViewButton(),
                        Expanded(child: SearchProductInput()),
                        AddCustomAmountButton(),
                      ],
                    ),
                  ),
                  Expanded(flex: kFlexRight, child: AddCustomerButton()),
                ],
              ),
            ),
            Divider(color: Colors.grey, height: 1),
            Expanded(
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    flex: kFlexLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        spacing: 12,
                        children: [
                          CategorySelection(),
                          Expanded(
                            child: ProductList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(color: Colors.grey, width: 1),
                  Expanded(
                    flex: kFlexRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OrderModeInfo(),
                          Expanded(child: OrderItemList()),
                          Row(
                            spacing: 4,
                            children: [
                              Expanded(
                                flex: 1,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onPressed: () {},
                                  label: Text("Simpan"),
                                  icon: const Icon(Icons.save),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onPressed: () {},
                                  label: Text("Diskon"),
                                  icon: const Icon(Icons.discount),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  ),
                                  onPressed: () {},
                                  label: Text("Batal"),
                                  icon: const Icon(Icons.cancel),
                                ),
                              ),
                            ],
                          ),
                          PayButton(),
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
          onDebounce: () => ref.read(searchProductNotifierProvider.notifier).setSearch(v),
        );
      },
      decoration: InputDecoration(
        hintText: "Cari Produk",
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ts = ref.watch(searchProductNotifierProvider);
    return ThemedButton(
      onPressed: () {},
      size: ButtonSize.large,
      icon: const Icon(Icons.add),
      text: Text('Custom Amount $ts'),
      variant: ButtonVariant.ghost,
    );
  }
}

class AddCustomerButton extends ConsumerWidget {
  const AddCustomerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: ThemedButton(
        size: ButtonSize.large,
        variant: ButtonVariant.outline,
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        text: Text('Pelanggan'),
      ),
    );
  }
}

class OrderModeInfo extends ConsumerWidget {
  const OrderModeInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);
    final buttonText = "${cart.saleMode.name} (${cart.pax} Pax)";

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
      child: Text("Bayar  |  Rp. 10.000"),
    );
  }
}

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchProductNotifierProvider);
    final category = ref.watch(categoryFilterNotifierProvider);
    var products = ref.watch(productDataProvider).products;

    if (category.id != ProductCategory.kIdAll) {
      products = products.where((p) => p.categoryId == category.id).toList();
    }

    if (search.isNotEmpty) {
      products = products.where((p) => p.name.contains(search)).toList();
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 19 / 8,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4,
        children: [
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            Formatter.toIdr.format(product.price),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class OrderItemList extends ConsumerWidget {
  const OrderItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 16),
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) {
        return OrderItemCard();
      },
    );
  }
}

class OrderItemCard extends ConsumerWidget {
  const OrderItemCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 32,
          child: Text("100"),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama produk",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                "Variant",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "Note",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.clear)),
      ],
    );
  }
}
