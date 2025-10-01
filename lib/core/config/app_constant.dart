abstract class AppConstants {
  static const appName = 'Ikki POS';
  static const appVersion = '1.0.0';

  static const authDeviceCodeLen = 6;
  static const pinLength = 4;
}

enum UserRole { employee, admin }

enum ShiftStatus { open, close }

enum OutletDeviceType {
  cashier,
  kitchen,
}
