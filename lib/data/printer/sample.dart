import 'dart:convert';
import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import '../../shared/utils/formatter.dart';

// Solution 1: Use smaller text sizes explicitly
Future<List<int>> smallerFontTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  // Use size1 (normal/smallest size) explicitly
  bytes += generator.text(
    'Normal size text (size1)',
    styles: PosStyles(
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ),
  );

  // Avoid size2 and size3 which are larger
  bytes += generator.text('Regular text without size styling');

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

// Solution 2: Use condensed font mode
Future<List<int>> condensedFontTicket() async {
  final profile = await CapabilityProfile.load(name: 'simple');
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  bytes += generator.setGlobalFont(PosFontType.fontA);
  bytes += generator.barcode(Barcode.codabar([1, 2, 3]));
  bytes += generator.text(
    'Teste Network print',
  );
  // bytes += generator.text(
  //   'This is Font A (normal)',
  //   styles: const PosStyles(
  //     fontType: PosFontType.fontA,
  //     align: PosAlign.center,
  //     bold: true,
  //   ),
  // );
  bytes += generator.feed(1);
  return bytes;
}

// Solution 3: Custom ESC/POS commands for precise control
Future<List<int>> customFontSizeTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  // Add raw ESC/POS commands for font control
  // ESC ! n - Select print mode
  // Bit 0: Font A(0)/Font B(1)
  // Bit 3: Emphasized/Bold
  // Bit 4: Double height
  // Bit 5: Double width

  // Font B (smaller font)
  bytes += [0x1B, 0x21, 0x01]; // ESC ! 1 (Font B)
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Small Font B text\n')));

  // Reset to Font A
  bytes += [0x1B, 0x21, 0x00]; // ESC ! 0 (Font A, normal)
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Normal Font A text\n')));

  // Even smaller with compressed mode
  bytes += [0x0F]; // SI (Condensed mode on)
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Condensed mode text\n')));
  bytes += [0x12]; // DC2 (Condensed mode off)

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

// Solution 4: Optimized receipt with controlled font sizes
Future<List<int>> optimizedReceiptTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  // Store header with Font B (smaller)
  // bytes += generator.setStyles(
  //   const PosStyles(
  //     fontType: PosFontType.fontA,
  //     align: PosAlign.center,
  //     bold: true,
  //   ),
  // );
  bytes += generator.text(
    'MY STORE NAME',
  );
  bytes += generator.hr(ch: '=', len: 32);
  bytes += generator.feed(1);

  // // Address with even smaller font
  // bytes += [0x0F]; // Condensed mode
  // bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('123 Main Street, City\n')));
  // bytes += [0x12]; // Condensed mode off

  // bytes += generator.hr();
  // bytes += generator.text(
  //   'Teste Network print',
  //   maxCharsPerLine: 32,
  //   styles: const PosStyles.defaults().copyWith(align: PosAlign.center),
  // );

  // // Product items with Font B
  // bytes += generator.setStyles(PosStyles(fontType: PosFontType.fontB));
  // bytes += generator.text('Item 1');

  // // Using row for better alignment with smaller fonts
  // bytes += generator.row([
  //   PosColumn(
  //     text: 'Item 1',
  //     width: 6,
  //     styles: PosStyles(fontType: PosFontType.fontB),
  //   ),
  //   PosColumn(
  //     text: '2x',
  //     width: 2,
  //     styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center),
  //   ),
  //   PosColumn(
  //     text: '\$5.00',
  //     width: 4,
  //     styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.right),
  //   ),
  // ]);

  // bytes += generator.row([
  //   PosColumn(
  //     text: 'Long Item Name Here',
  //     width: 6,
  //     styles: PosStyles(fontType: PosFontType.fontB),
  //   ),
  //   PosColumn(
  //     text: '1x',
  //     width: 2,
  //     styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.center),
  //   ),
  //   PosColumn(
  //     text: '\$12.99',
  //     width: 4,
  //     styles: PosStyles(fontType: PosFontType.fontB, align: PosAlign.right),
  //   ),
  // ]);

  // bytes += generator.hr();

  // // Total with slightly larger but controlled font
  // bytes += generator.row([
  //   PosColumn(
  //     text: 'TOTAL:',
  //     width: 8,
  //     styles: PosStyles(
  //       fontType: PosFontType.fontA,
  //       bold: true,
  //     ),
  //   ),
  //   PosColumn(
  //     text: '\$17.99',
  //     width: 4,
  //     styles: PosStyles(
  //       fontType: PosFontType.fontA,
  //       bold: true,
  //       align: PosAlign.right,
  //     ),
  //   ),
  // ]);

  return bytes;
}

// Solution 5: Test different paper sizes (this affects character density)
Future<List<int>> testPaperSizes() async {
  final profile = await CapabilityProfile.load();

  // Try mm80 instead of mm58 for different character density
  final generator = Generator(PaperSize.mm80, profile);
  var bytes = <int>[];

  bytes += generator.text('Testing with 80mm paper size');
  bytes += generator.text('More characters fit per line with wider paper');

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

// Solution 6: Character density control
Future<List<int>> densityControlTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  // Raw ESC/POS command for print density
  // ESC 7 n1 n2 n3 - Set print density
  bytes += [0x1B, 0x37, 0x07, 0x64, 0x64]; // Lighter density
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Light density text\n')));

  bytes += [0x1B, 0x37, 0x0F, 0x64, 0x64]; // Normal density
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Normal density text\n')));

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}

// Complete example combining all techniques
Future<List<int>> completeOptimizedTicket() async {
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  // Header with Font B
  bytes += generator.setStyles(
    PosStyles(
      fontType: PosFontType.fontB,
      align: PosAlign.center,
      bold: true,
    ),
  );
  bytes += generator.text('RECEIPT');

  // Store info with condensed mode
  bytes += [0x0F]; // Condensed on
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Store Name Here\n')));
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('123 Address St, City\n')));
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('Phone: (555) 123-4567\n')));
  bytes += [0x12]; // Condensed off

  bytes += generator.hr();

  // Date/time with Font B
  bytes += generator.setStyles(PosStyles(fontType: PosFontType.fontB));
  bytes += generator.text('${DateTime.now().toString().substring(0, 16)}');
  bytes += generator.feed(1);

  // Items header
  bytes += generator.text('QTY  ITEM                 PRICE');
  bytes += generator.hr(ch: '-');

  // Sample items with optimal formatting
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('2x   Coffee            \$6.00\n')));
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('1x   Sandwich           \$12.50\n')));
  bytes += generator.textEncoded(Uint8List.fromList(utf8.encode('1x   Cookie              \$2.50\n')));

  bytes += generator.hr(ch: '-');

  // Totals with controlled sizing
  bytes += generator.row([
    PosColumn(text: 'Subtotal:', width: 8),
    PosColumn(
      text: '\$21.00',
      width: 4,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);

  bytes += generator.row([
    PosColumn(text: 'Tax:', width: 8),
    PosColumn(
      text: '\$1.68',
      width: 4,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);

  // Total with Font A but size1
  bytes += generator.row([
    PosColumn(
      text: 'TOTAL:',
      width: 8,
      styles: PosStyles(
        fontType: PosFontType.fontA,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ),
    PosColumn(
      text: '\$22.68',
      width: 4,
      styles: PosStyles(
        fontType: PosFontType.fontA,
        bold: true,
        align: PosAlign.right,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ),
  ]);

  bytes += generator.feed(1);
  bytes += generator.text('Thank you!', styles: PosStyles(align: PosAlign.center));
  bytes += generator.feed(3);
  bytes += generator.cut();

  return bytes;
}

Future<List<int>> receiptSample() async {
  final profile = await CapabilityProfile.load(name: 'simple');
  final generator = Generator(PaperSize.mm58, profile);
  var bytes = <int>[];

  bytes += [0x1B, 0x21, 0x00]; // ESC ! 0 (Font A, normal)
  // bytes += [0x1B, 0x37, 0x07, 0x64, 0x64]; // Lighter density

  bytes += generator.text('IKKI COFFEE', styles: const PosStyles(align: PosAlign.center));
  bytes += generator.hr();

  bytes += generator.row(rowHeader('Penjualan', 'POS/123/001231'));
  bytes += generator.row(rowHeader('Tanggal', '2023-01-01 12:00'));
  bytes += generator.row(rowHeader('No Meja', '12'));
  bytes += generator.row(rowHeader('Mode', 'Dine In'));
  bytes += generator.row(rowHeader('Kasir', 'Rizqy Nugroho'));
  bytes += generator.hr();

  bytes += generator.row(rowItem(1, 'Cappucino', 1000));
  bytes += generator.row(rowItem(2, 'Espresso', 1000));
  bytes += generator.row(rowItem(3, 'Latte', 1000000));
  bytes += generator.row(rowItem(3, 'Nasi Goreng Sangat Panas', 1000000));
  bytes += generator.row(rowItem(300, 'Cake', 1000000));
  bytes += generator.hr();

  bytes += generator.text('2 Item');

  bytes += generator.row([
    PosColumn(
      text: 'Subtotal',
      width: 7,
      styles: const PosStyles(align: PosAlign.right),
    ),
    PosColumn(
      text: ':',
      width: 1,
      styles: const PosStyles(align: PosAlign.center),
    ),
    PosColumn(
      text: Formatter.toIdrNoSymbol.format(10000000),
      width: 4,
      styles: const PosStyles(align: PosAlign.right),
    ),
  ]);

  bytes += [0x1B, 0x37, 0x07, 0x64, 0x64]; // Lighter density
  bytes += generator.row([
    PosColumn(
      text: 'Grand Total',
      width: 7,
      styles: const PosStyles(bold: true, align: PosAlign.right),
    ),
    PosColumn(
      text: ':',
      width: 1,
      styles: const PosStyles(bold: true, align: PosAlign.center),
    ),
    PosColumn(
      text: Formatter.toIdrNoSymbol.format(10000000),
      width: 4,
      styles: const PosStyles(bold: true, align: PosAlign.right),
    ),
  ]);

  bytes += [0x1B, 0x37, 0x07, 0x64, 0x64]; // Lighter density
  bytes += generator.row([
    PosColumn(
      text: 'Cash',
      width: 7,
      styles: const PosStyles(bold: true, align: PosAlign.right),
    ),
    PosColumn(
      text: ':',
      width: 1,
      styles: const PosStyles(bold: true, align: PosAlign.center),
    ),
    PosColumn(
      text: Formatter.toIdrNoSymbol.format(10000000),
      width: 4,
      styles: const PosStyles(bold: true, align: PosAlign.right),
    ),
  ]);

  bytes += generator.feed(1);

  return bytes;
}

List<PosColumn> rowHeader(String label, String value) {
  return [
    PosColumn(text: label, width: 4),
    PosColumn(text: ':', width: 1),
    PosColumn(text: value, width: 7),
  ];
}

List<PosColumn> rowItem(int qty, String menu, int price) {
  return [
    // ignore: avoid_redundant_argument_values
    PosColumn(text: qty.toString(), width: 1),
    PosColumn(text: menu, width: 7),
    PosColumn(
      text: Formatter.toIdrNoSymbol.format(price),
      width: 4,
      styles: const PosStyles(align: PosAlign.right),
    ),
  ];
}
