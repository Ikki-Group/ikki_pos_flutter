import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/core/config/app_palette.dart';
import 'package:ikki_pos_flutter/data/product/product_model.dart';
import 'package:ikki_pos_flutter/data/product/product_provider.dart';
import 'package:ikki_pos_flutter/features/cart/widgets/category_selection.dart';
import 'package:ikki_pos_flutter/router/ikki_router.dart';
import 'package:ikki_pos_flutter/shared/utils/formatter.dart';

const int kFlexLeft = 70;
const int kFlexRight = 30;

class CartSelectionPage extends ConsumerStatefulWidget {
  const CartSelectionPage({super.key});

  @override
  CartSelectionPageState createState() => CartSelectionPageState();
}

class CartSelectionPageState extends ConsumerState<CartSelectionPage> {
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
              padding: const EdgeInsets.only(bottom: 8),
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
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        spacing: 8,
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
                      padding: const EdgeInsets.only(top: 8),
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
  const SearchProductInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Cari Produk",
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        suffixIcon: Icon(Icons.clear, color: Colors.grey[600]),
      ),
    );
  }
}

class AddCustomAmountButton extends ConsumerWidget {
  const AddCustomAmountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Custom Amount'),
    );
  }
}

class AddCustomerButton extends ConsumerWidget {
  const AddCustomerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(Icons.person_add),
      label: const Text('Pelanggan'),
    );
  }
}

class OrderModeInfo extends ConsumerWidget {
  const OrderModeInfo({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        fixedSize: const Size.fromWidth(double.infinity),
      ),
      onPressed: () {},
      child: Text("Order Mode"),
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
      child: Text("Pay"),
    );
  }
}

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productDataProvider).products;

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 19 / 8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
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
        spacing: 3,
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
