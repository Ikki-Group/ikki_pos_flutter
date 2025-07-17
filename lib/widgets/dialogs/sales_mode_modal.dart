import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ikki_pos_flutter/data/cart/cart_notifier.dart';
import 'package:ikki_pos_flutter/data/sale/sale_model.dart';
import 'package:ikki_pos_flutter/router/ikki_router.dart';
import 'package:ikki_pos_flutter/widgets/ui/button_variants.dart';
import 'package:ikki_pos_flutter/widgets/ui/ikki_dialog.dart';

class SalesModeModal extends ConsumerStatefulWidget {
  const SalesModeModal({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SalesModeModal();
      },
    );
  }

  @override
  ConsumerState createState() => _SalesModeModalState();
}

class _SalesModeModalState extends ConsumerState<SalesModeModal> {
  late ScrollController _scrollController;
  late List<SaleMode> _saleModes;

  late int _pax;
  late SaleMode _selectedSaleMode;

  @override
  void initState() {
    super.initState();
    final cart = ref.read(cartNotifierProvider);

    _saleModes = SaleMode.values;
    _selectedSaleMode = cart.saleMode.id.isNotEmpty ? cart.saleMode : _saleModes[0];
    _pax = cart.pax;
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedPax();
    });
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _onProcessPressed() async {
    final cart = ref.read(cartNotifierProvider.notifier);
    await cart.newCart(_pax, _selectedSaleMode);

    final String? routeName = GoRouter.of(context).state.name;
    if (routeName == IkkiRouter.cartSelection.name) {
      _onClose();
    } else {
      context.go(IkkiRouter.cartSelection.path);
    }
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

  static const double _chipWidth = 50.0;
  static const double _chipSpacing = 8.0;
  static const double _itemWidth = _chipWidth + _chipSpacing;

  double _calculateScrollOffset(int pax) {
    final itemOffset = (pax - 1) * _itemWidth;
    final viewportCenter = _scrollController.position.viewportDimension / 2;
    final itemCenter = _chipWidth / 2;

    return (itemOffset - viewportCenter + itemCenter).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAllowedToProceed = _pax > 0;

    return IkkiDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IkkiDialogTitle(title: "Mode Penjualan"),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Jumlah Pax",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
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
                              padding: const EdgeInsets.all(0),
                              label: SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "$value",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ),
                              ),
                              selected: selected,
                              showCheckmark: false,
                              onSelected: (selected) {
                                setState(() {
                                  _pax = value;
                                });
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
                    Text(
                      "Mode Penjualan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                          final isSelected = _selectedSaleMode.id == saleMode.id;

                          return ChoiceChip.elevated(
                            padding: const EdgeInsets.all(16),
                            showCheckmark: false,
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedSaleMode = saleMode;
                              });
                            },
                            label: Text(
                              saleMode.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ThemedButton.cancel(
                  onPressed: _onClose,
                ),
                const SizedBox(width: 8),
                ThemedButton.process(
                  onPressed: isAllowedToProceed ? _onProcessPressed : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
