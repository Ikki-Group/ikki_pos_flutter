import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import 'printer_enum.dart';
import 'printer_model.dart';

abstract class PrinterTemplate {
  String get name;

  Future<List<int>> build(Generator generator);
}

extension PrinterModelX on PrinterModel {
  Printer get printer {
    final connectionType = switch (this.connectionType) {
      PrinterConnectionType.bluetooth => ConnectionType.BLE,
      PrinterConnectionType.lan => ConnectionType.NETWORK,
    };

    return Printer(
      name: name,
      address: address,
      connectionType: connectionType,
      isConnected: true,
    );
  }
}
