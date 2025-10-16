import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:fpdart/fpdart.dart';

import '../../cart/model/cart_state.dart';
import '../../outlet/model/outlet_state.dart';
import 'printer_utils.dart';

class TemplateReceiptChecker extends PrinterTemplate {
  TemplateReceiptChecker(this.cart, this.outlet);
  final CartState cart;
  final OutletState outlet;

  @override
  String get name => 'TemplateReceiptChecker';

  @override
  Future<List<int>> build(Generator generator) async {
    final batchId = cart.batchId;

    var bytes = initBytes();
    bytes += generator.feed(2);

    bytes += generator.text(
      'Checker',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      cart.rc,
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

    bytes += generator.feed(1);

    final itemsInBatch = cart.items.filter((item) => item.batchId == batchId);

    assert(itemsInBatch.isNotEmpty, 'Items in batch $batchId is empty');

    for (final item in itemsInBatch) {
      bytes += generator.row([
        PosColumn(
          text: item.qty.toString(),
          styles: const PosStyles(align: PosAlign.left),
          width: 2,
        ),
        PosColumn(
          text: item.product.name,
          width: 10,
          styles: const PosStyles(align: PosAlign.left),
        ),
      ]);
    }

    bytes += generator.feed(2);

    return bytes;
  }
}
