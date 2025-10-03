import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:fpdart/fpdart.dart';

import '../../cart/model/cart_state.dart';
import '../../outlet/data/outlet_state.dart';
import 'printer_utils.dart';

class TemplateReceiptChecker extends PrinterTemplate {
  TemplateReceiptChecker(this.cart, this.outlet);
  final CartState cart;
  final OutletState outlet;

  @override
  String get name => 'TemplateReceiptChecker';

  @override
  Future<List<int>> build(Generator generator) async {
    var bytes = <int>[];
    final batchId = cart.batchId;

    bytes += generator.clearStyle();
    bytes += [0x1B, 0x21, 0x00]; // ESC ! 0 (Font A, normal)
    bytes += generator.setStyles(
      const PosStyles(
        fontType: PosFontType.fontA,
        align: PosAlign.center,
      ),
    );
    bytes += generator.feed(1);

    bytes += generator.text(
      'Checker',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      'Pesanan ke $batchId',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.feed(1);

    bytes += generator.text(
      '-- ${cart.salesMode.toString().toUpperCase()} --',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    final itemsInBatch = cart.items.filter((item) => item.batchId == batchId);

    assert(itemsInBatch.isNotEmpty, 'Items in batch $batchId is empty');

    for (final item in itemsInBatch) {
      bytes += generator.row([
        PosColumn(
          text: item.qty.toString(),
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: item.product.name,
          width: 10,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    return bytes;
  }
}
