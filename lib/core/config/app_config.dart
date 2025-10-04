abstract class AppConfig {
  static const String devUrl = 'http://localhost:4000';
  static const String prodUrl = 'https://ikki-be.fly.dev';

  static const mqttHost = 'l16f91f0.ala.eu-central-1.emqxsl.com';
  static const mqttPort = 8883;
  static const mqttWsPort = 8084;
  // static const mqttPort = 1883;
  // static const mqttWsPort = 8083;
  static const mqttUsername = 'mobile';
  static const mqttPassword = 'supersecret';
}

abstract class ApiConfig {
  static String get baseUrl => AppConfig.prodUrl;

  static const String outletDeviceClaim = '/outlet/device/claim';
  static const String outletDeviceSync = '/outlet/device/sync';
}
