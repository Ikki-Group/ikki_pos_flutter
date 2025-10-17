abstract class AppConstants {
  static const appName = 'Ikki POS';
  static const appVersion = '1.0.0';
  static const developerName = 'Rizqy Nugroho';

  static const authDeviceCodeLen = 6;
  static const pinLength = 4;
}

enum BillType {
  open,
  close,
}

enum CartStatus {
  init,
  process,
  success,
  fail,
}

enum SalesMode {
  dineIn(value: 'Dine In'),
  takeAway(value: 'Take Away');

  const SalesMode({required this.value});
  final String value;

  @override
  String toString() => value;

  static SalesMode fromString(String value) {
    return values.firstWhere((e) => e.value == value);
  }
}

enum SalesSource {
  cashier,
  online,
}

enum PaymentType {
  cash,
  cashless,
}
