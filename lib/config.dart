const bool isDebug = false;

class Config {
  Config._();

  static const bool apiLogOpen = true;

  static const String localUrl = 'http://192.168.1.8:8000';

  static const String netServer = 'https://apis.libin.zone';

  static const String baseUrl = isDebug ? localUrl : netServer;
}
