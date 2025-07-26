import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/pos_theme.dart';
import '../../data/cart/cart.provider.dart';
import '../../data/sale/sale.model.dart';
import '../../router/ikki_router.dart';
import '../ui/button_variants.dart';
import 'ikki_dialog.dart';

class SalesModeDialog extends ConsumerStatefulWidget {
  const SalesModeDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const SalesModeDialog();
      },
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SalesModeDialogState();
}

class _SalesModeDialogState extends ConsumerState<SalesModeDialog> {
  static const double _chipWidth = 50;
  static const double _chipSpacing = 8;
  static const double _itemWidth = _chipWidth + _chipSpacing;

  late ScrollController _scrollController;
  late List<SaleMode> _saleModes;

  late int _pax;
  late SaleMode? _selectedSaleMode;

  @override
  void initState() {
    super.initState();

    final cart = ref.read(cartStateProvider);

    _saleModes = SaleMode.values;
    // _selectedSaleMode = cart.saleMode!.id.isNotEmpty ? cart.saleMode : _saleModes[0];
    _selectedSaleMode = _saleModes[0];
    _pax = cart.pax;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedPax();
    });
  }

  void _scrollToSelectedPax() {
    if (_scrollController.hasClients) {
      final targetOffset = _calculateScrollOffset(_pax);
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  double _calculateScrollOffset(int pax) {
    final itemOffset = (pax - 1) * _itemWidth;
    final viewportCenter = _scrollController.position.viewportDimension / 2;
    const itemCenter = _chipWidth / 2;

    return (itemOffset - viewportCenter + itemCenter).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  Future<void> _onProcessPressed() async {
    final routeName = GoRouter.of(context).state.name;
    if (routeName == IkkiRouter.cart.name) {
      ref
          .read(cartStateProvider.notifier)
          .setState(
            (old) => old.copyWith(
              pax: _pax,
              // saleMode: _selectedSaleMode,
            ),
          );
      _onClose();
    } else {
      await ref.read(cartStateProvider.notifier).newCart(_pax, _selectedSaleMode!);
      if (!mounted) return;
      context.goNamed(IkkiRouter.cart.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IkkiDialog(
      title: 'Mode Penjualan',
      constraints: const BoxConstraints(maxWidth: 700),
      mainAxisSize: MainAxisSize.min,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ThemedButton.cancel(
            onPressed: _onClose,
          ),
          const SizedBox(width: 8),
          ThemedButton.process(
            onPressed: _onProcessPressed,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Jumlah Pax', style: context.textTheme.labelMedium),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 50),
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 100,
              itemBuilder: (context, index) {
                final value = index + 1;
                final selected = _pax == value;

                return AspectRatio(
                  aspectRatio: 1,
                  child: ChoiceChip.elevated(
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
                      _pax = value;
                      setState(() {});
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 8);
              },
            ),
          ),
          const SizedBox(height: 24),
          Text('Mode Penjualan', style: context.textTheme.labelMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.separated(
              itemCount: _saleModes.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 8);
              },
              itemBuilder: (context, index) {
                final saleMode = _saleModes[index];
                final isSelected = _selectedSaleMode?.id == saleMode.id;

                return ChoiceChip(
                  padding: const EdgeInsets.all(16),
                  showCheckmark: false,
                  selected: isSelected,
                  onSelected: (selected) {
                    _selectedSaleMode = saleMode;
                    setState(() {});
                  },
                  label: Text(
                    saleMode.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
