const bool isDebug = true;

class Config {
  Config._();

  static const bool apiLogOpen = true;

  static const String localUrl = 'http://192.168.10.6:8000';

  static const String netServer = 'https://apis.libin.zone';

  static const String webServer = 'https://libin.zone';

  static const String baseUrl = isDebug ? localUrl : netServer;
}
