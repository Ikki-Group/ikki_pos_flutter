abstract class AppConfig {
  static const String devUrl = 'http://localhost:4000';
  static const String prodUrl = 'https://ikki-be.fly.dev';
}

abstract class ApiConfig {
  static String get baseUrl => AppConfig.prodUrl;

  static const String outletDeviceClaim = '/outlet/device/claim';
  static const String outletDeviceSync = '/outlet/device/sync';
}
