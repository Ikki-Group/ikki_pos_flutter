import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/formatter.dart';
import '../../cart/model/cart_extension.dart';
import '../../cart/model/cart_state.dart';
import '../../outlet/model/outlet_state.dart';
import 'printer_utils.dart';

class TemplateReceipt extends PrinterTemplate {
  TemplateReceipt(this.cart, this.outlet);

  final CartState cart;
  final OutletState outlet;

  @override
  String get name => 'TemplateReceipt';

  @override
  Future<List<int>> build(Generator generator) async {
    var bytes = initBytes();
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
    bytes += generator.row(rowHeader('Mode', cart.salesMode.toString().toUpperCase()));

    // bytes += generator.row(rowHeader('Kasir', cart.cashier.name));

    if (cart.customer != null && cart.customer!.name.isNotEmpty) {
      bytes += generator.row(rowHeader('No Meja', cart.customer!.name));
    }

    bytes += generator.hr(ch: '=', len: 32);
    bytes += generator.text(
      '--- ${cart.salesMode.value} ---',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.feed(1);

    for (final item in cart.items) {
      bytes += rowCartItem(item, generator);
    }
    bytes += generator.hr(len: 32);

    bytes += generator.text(" ${cart.itemsCount} Items");
    bytes += generator.row([
      PosColumn(
        text: 'Subtotal',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: cart.gross.toIdrNoSymbol,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr(ch: '-', len: 32);

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

    bytes += generator.feed(1);

    // Footer
    bytes += generator.text(
      '''
Terima kasih atas pesanan anda.

Ikki Coffee
123456
''',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
      ),
    );

    bytes += generator.feed(3);

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
      PosColumn(text: item.product.name, width: 12),
    ]);

    bytes += generator.row([
      PosColumn(
        text: item.qty.toString(),
        width: 1,
      ),
      PosColumn(
        text: "x @${item.price.toIdrNoSymbol}",
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
