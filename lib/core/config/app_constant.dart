abstract class AppConstants {
  static const appName = 'Ikki POS';
  static const appVersion = '1.0.0';

  static const authDeviceCodeLen = 6;
  static const pinLength = 4;
}

enum UserRole {
  employee,
  admin,
}

enum ShiftStatus {
  open,
  close,
}

enum OutletDeviceType {
  cashier,
  kitchen,
}

enum BillType {
  open,
  close,
}

enum CartStatus {
  process,
  success,
  fail,
}

enum SalesMode {
  dineIn(value: 'Dine-in'),
  takeAway(value: 'Take Away');

  const SalesMode({required this.value});
  final String value;

  @override
  String toString() => value;

  static SalesMode fromString(String value) {
    return values.firstWhere((e) => e.value == value);
  }
}

enum CartSource {
  cashier,
  online,
}

enum PaymentType {
  cash,
  cashless,
}
