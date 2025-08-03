import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/cart/cart_state.dart';
import '../../data/sale/sale_enum.dart';
import '../../router/ikki_router.dart';
import '../ui/button_variants.dart';
import '../ui/pos_dialog.dart';

class SalesModeDialog extends ConsumerStatefulWidget {
  const SalesModeDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalesModeDialogState();

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const SalesModeDialog();
      },
    );
  }
}

const _kChipWidth = 50.0;
const _kChipSpacing = 8.0;
const double _kItemWidth = _kChipWidth + _kChipSpacing;

class _SalesModeDialogState extends ConsumerState<SalesModeDialog> {
  late ScrollController scrollController;

  int pax = 1;
  SaleMode selectedSaleMode = SaleMode.dineIn;

  @override
  void initState() {
    super.initState();
    final cart = ref.read(cartStateProvider);

    selectedSaleMode = cart.saleMode;
    pax = cart.pax;
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedPax();
    });
  }

  void scrollToSelectedPax() {
    if (scrollController.hasClients) {
      final targetOffset = calculateScrollOffset(pax);
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  double calculateScrollOffset(int pax) {
    final itemOffset = (pax - 1) * _kItemWidth;
    final viewportCenter = scrollController.position.viewportDimension / 2;
    const itemCenter = _kChipWidth / 2;

    return (itemOffset - viewportCenter + itemCenter).clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );
  }

  void onClose() {
    Navigator.of(context).pop();
  }

  Future<void> onProcessPressed() async {
    final routeName = GoRouter.of(context).state.name;
    if (routeName == IkkiRouter.cart.name) {
      ref.read(cartStateProvider.notifier).updateSalesAndPax(selectedSaleMode, pax);
      onClose();
    } else {
      await ref.read(cartStateProvider.notifier).newCart(pax, selectedSaleMode);
      if (!mounted) return;
      context.goNamed(IkkiRouter.cart.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return PosDialog(
      title: 'Mode Penjualan',
      constraints: const BoxConstraints(maxWidth: 700),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ThemedButton.cancel(onPressed: onClose),
          const SizedBox(width: 8),
          ThemedButton.process(onPressed: onProcessPressed),
        ],
      ),
      children: [
        Text('Jumlah Pax', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 50),
          child: ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 100,
            itemBuilder: (context, index) {
              final value = index + 1;
              final selected = pax == value;

              return FilterChip(
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                label: SizedBox.square(
                  dimension: 50,
                  child: Center(
                    child: Text('$value', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                selected: selected,
                showCheckmark: false,
                onSelected: (selected) {
                  pax = value;
                  setState(() {});
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 8);
            },
          ),
        ),
        const SizedBox(height: 24),
        Text('Mode Penjualan', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.separated(
            itemCount: SaleMode.values.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final saleMode = SaleMode.values[index];
              final isSelected = selectedSaleMode == saleMode;

              return ChoiceChip(
                // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                showCheckmark: false,
                selected: isSelected,
                onSelected: (selected) {
                  selectedSaleMode = saleMode;
                  setState(() {});
                },
                label: Text(saleMode.value),
              );
            },
          ),
        ),
      ],
    );
  }
}
