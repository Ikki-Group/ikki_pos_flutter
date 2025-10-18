abstract class AppConfig {
  static const String devUrl = 'http://localhost:4000';
  static const String prodUrl = 'https://ikki-be.fly.dev';

  static const String sentryDsn =
      'https://2cf87475523ae7e6b299b11f90ce19ad@o4507870585880576.ingest.us.sentry.io/4510130824609792';

  static const mqttHost = 'l16f91f0.ala.eu-central-1.emqxsl.com';
  static const mqttPort = 8883;
  static const mqttWsPort = 8084;
  static const mqttUsername = 'mobile';
  static const mqttPassword = 'supersecret';

  static const String sembastDb = "ikki.db";
}

abstract class ApiConfig {
  // static String get baseUrl => AppConfig.devUrl;
  static String get baseUrl => AppConfig.prodUrl;

  static const String outletDeviceClaim = '/outlet/device/claim';
  static const String outletDeviceSync = '/outlet/device/sync';

  static const String outletShiftOpen = '/outlet/shift-session/open';
  static const String outletShiftClose = '/outlet/shift-session/close';
  static const String outletShiftSync = '/outlet/shift-session/sync';
}
