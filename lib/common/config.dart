const bool isDebug = true;

class Config {
  Config._();

  static const bool apiLogOpen = true;

  static const String localUrl = 'http://192.168.1.80:5000';

  static const String netServer = 'http://1.14.252.115';

  static const String baseUrl = isDebug ? localUrl : '$netServer:5000';
}
