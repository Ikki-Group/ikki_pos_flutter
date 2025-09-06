import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../printer_utils.dart';

// Future<void> templatePrintInfo(FlutterThermalPrinter instance, Printer printer) async {
//   final profile = await CapabilityProfile.load();
//   final generator = Generator(PaperSize.mm58, profile);
//   var bytes = <int>[];

//   bytes += generator.feed(2);
//   bytes += generator.text('Printer Info', styles: const PosStyles(align: PosAlign.center));
//   bytes += generator.hr();
//   bytes += generator.text(printer.toJson().toString());
//   bytes += generator.hr();
//   bytes += generator.feed(2);

//   final chunks = bytes.splitByLength(182);
//   for (final chunk in chunks) {
//     await instance.printData(printer, chunk, longData: true);
//   }
// }

class PrinterTempInfo extends PrinterTemplate {
  PrinterTempInfo(this.printer);
  final Printer printer;

  @override
  String get name => 'Printer Temp Info';

  @override
  Future<List<int>> build(Generator generator) async {
    var bytes = <int>[];

    bytes += generator.feed(2);
    bytes += generator.text('Printer Info', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    bytes += generator.text(printer.toJson().toString());
    bytes += generator.hr();
    bytes += generator.feed(2);
    return bytes;
  }
}
