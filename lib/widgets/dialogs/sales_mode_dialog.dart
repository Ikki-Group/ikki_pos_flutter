import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/ui/pos_button.dart';
import '../../core/config/app_constant.dart';
import '../../features/auth/provider/user_provider.dart';
import '../../features/cart/provider/cart_provider.dart';
import '../../features/outlet/provider/outlet_provider.dart';
import '../../router/app_router.dart';
import '../ui/pos_dialog_two.dart';

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

const _chipWidth = 50.0;
const _chipSpacing = 8.0;
const double _itemWidth = _chipWidth + _chipSpacing;

class _SalesModeDialogState extends ConsumerState<SalesModeDialog> {
  late ScrollController scrollController;

  int pax = 1;
  SalesMode selectedSalesMode = SalesMode.dineIn;

  @override
  void initState() {
    super.initState();
    final cart = ref.read(cartProvider);

    selectedSalesMode = cart.salesMode;
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
    final itemOffset = (pax - 1) * _itemWidth;
    final viewportCenter = scrollController.position.viewportDimension / 2;
    const itemCenter = _chipWidth / 2;

    return (itemOffset - viewportCenter + itemCenter).clamp(
      0.0,
      scrollController.position.maxScrollExtent,
    );
  }

  void onClose() {
    Navigator.of(context).pop();
  }

  void onProcessPressed() {
    final routeName = GoRouter.of(context).state.name;
    if (routeName == AppRouter.cart.name) {
      ref
          .read(cartProvider.notifier)
          .setSalesAndPax(
            selectedSalesMode,
            pax,
          );
      onClose();
    } else {
      final outlet = ref.read(outletProvider);
      final user = ref.read(userProvider).selectedUser;
      ref
          .read(cartProvider.notifier)
          .createNew(
            pax: pax,
            salesMode: selectedSalesMode,
            outletState: outlet,
            user: user,
          );
      context.goNamed(AppRouter.cart.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final mq = MediaQuery.of(context);
    final width = mq.size.width * 0.6;

    return PosDialogTwo(
      title: 'Mode Penjualan',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PosButton.cancel(onPressed: onClose),
          const SizedBox(width: 8),
          PosButton.process(onPressed: onProcessPressed),
        ],
      ),
      children: [
        Text('Jumlah Pax', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          width: width,
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
            separatorBuilder: (_, _) => const SizedBox(width: 8),
          ),
        ),
        const SizedBox(height: 16),
        Text('Mode Penjualan', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          width: width,
          height: 50,
          child: ListView.separated(
            itemCount: SalesMode.values.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final salesMode = SalesMode.values[index];
              final isSelected = selectedSalesMode == salesMode;

              return ChoiceChip(
                showCheckmark: false,
                selected: isSelected,
                onSelected: (selected) {
                  selectedSalesMode = salesMode;
                  setState(() {});
                },
                label: Text(salesMode.value),
              );
            },
          ),
        ),
      ],
    );
  }
}
