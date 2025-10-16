enum PrinterConnectionType {
  bluetooth(label: 'Bluetooth'),
  lan(label: 'LAN/WIFI');

  const PrinterConnectionType({required this.label});
  final String label;
}

enum PrinterTag { receipt, checker, main }
