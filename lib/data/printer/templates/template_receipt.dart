import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/formatter.dart';
import '../../cart/cart_model.dart';
import '../../outlet/outlet_model.dart';
import '../printer_utils.dart';

class TemplateReceipt extends PrinterTemplate {
  TemplateReceipt(this.cart, this.outlet);

  final Cart cart;
  final OutletStateModel outlet;

  @override
  String get name => 'TemplateReceipt';

  @override
  Future<List<int>> build(Generator generator) async {
    var bytes = <int>[];

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
      outlet.outlet.name,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.feed(1);

    bytes += generator.row(rowHeader('Penjualan', cart.rc));

    final datetime = DateTime.parse(cart.createdAt);
    final date = DateFormat('dd-MM-yyyy HH:mm', 'id_ID').format(datetime);

    bytes += generator.row(rowHeader('Tanggal', date));
    bytes += generator.row(rowHeader('Mode', cart.saleMode.toString().toUpperCase()));

    // bytes += generator.row(rowHeader('Kasir', cart.cashier.name));

    if (cart.customer != null && cart.customer!.name.isNotEmpty) {
      bytes += generator.row(rowHeader('No Meja', cart.customer!.name));
    }

    bytes += generator.hr(ch: '=', len: 32);
    bytes += generator.text('--- Dine In ---', styles: const PosStyles(align: PosAlign.center, bold: true));

    for (final item in cart.items) {
      bytes += rowCartItem(item, generator);
    }
    bytes += generator.hr(len: 32);

    // ignore: join_return_with_assignment
    // bytes += generator.row(rowHeader('Total', cart.net.toIdrNoSymbol));
    bytes += generator.row([
      PosColumn(
        text: 'Subtotal',
        width: 8,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: cart.gross.toIdrNoSymbol,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 8,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
      PosColumn(
        text: cart.net.toIdrNoSymbol,
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.feed(2);

    return bytes;
  }

  List<PosColumn> rowHeader(String label, String value) {
    return [
      PosColumn(text: label, width: 4),
      PosColumn(text: ':', width: 1),
      PosColumn(text: value, width: 7),
    ];
  }

  List<int> rowCartItem(CartItem item, Generator generator) {
    final hasNote = item.note.isNotEmpty;
    var bytes = <int>[];

    bytes += generator.row([
      PosColumn(
        text: item.qty.toString(),
        width: 1,
      ),
      PosColumn(
        text: item.product.name,
        width: 8,
      ),
      PosColumn(
        text: item.gross.toIdrNoSymbol,
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    if (hasNote) {
      bytes += generator.row([
        PosColumn(width: 1),
        PosColumn(
          text: item.note,
          width: 9,
        ),
        PosColumn(),
      ]);
    }
    return bytes;
  }
}
