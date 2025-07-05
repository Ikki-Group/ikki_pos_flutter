import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ikki_pos_flutter/data/sale/sale_model.dart';
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
  SalesModeModalState createState() => SalesModeModalState();
}

class SalesModeModalState extends ConsumerState<SalesModeModal> {
  late List<SaleMode> _saleModes;
  int? _pax = 0;
  SaleMode? _selectedSaleMode;

  @override
  void initState() {
    super.initState();
    _saleModes = SaleMode.values;
  }

  @override
  Widget build(BuildContext context) {
    return IkkiDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              IkkiDialogTitle(title: "Mulai Penjualan"),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "Jumlah Pax",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          itemCount: 1000,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 8);
                          },
                          itemBuilder: (context, index) {
                            final value = index + 1;
                            final isSelected = value == _pax;

                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isSelected ? Colors.white : Colors.blue,
                                backgroundColor: isSelected ? Colors.blue : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.blue, width: 1),
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _pax = value;
                                });
                              },
                              child: Text(
                                '$value',
                                // "2",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Mode Penjualan",
                        style: TextStyle(
                          fontSize: 18,
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
                            final isSelected = _selectedSaleMode?.id == saleMode.id;

                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isSelected ? Colors.white : Colors.blue,
                                backgroundColor: isSelected ? Colors.blue : Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.blue, width: 1),
                                // padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedSaleMode = saleMode;
                                });
                              },
                              child: Text(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {},
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
