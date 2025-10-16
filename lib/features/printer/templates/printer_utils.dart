import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

import '../../../core/logger/talker_logger.dart';
import '../model/printer_enum.dart';
import '../model/printer_model.dart';

abstract class PrinterTemplate with PrinterUtils {
  String get name;

  Future<List<int>> build(Generator generator);
}

mixin class PrinterUtils {
  late Generator generator;

  void setup(Generator generator) {
    this.generator = generator;
  }

  List<int> initBytes() {
    logger.debug('initBytes');
    var bytes = <int>[];
    bytes += generator.clearStyle();
    bytes += [0x1B, 0x21, 0x00];
    bytes += generator.setStyles(
      const PosStyles(
        fontType: PosFontType.fontA,
        align: PosAlign.center,
      ),
    );

    return bytes;
  }
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
