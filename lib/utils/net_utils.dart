import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/constants.dart';

class NetUtils {
  const NetUtils._();

  static const bool _isProxyEnabled = false;
  static const String _proxyDestination = 'PROXY 192.168.1.23:8764';

  static const bool shouldLogRequest = false;

  static final Dio dio = Dio(_options);
  static final Dio tokenDio = Dio(_options);


  static Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    Options? options,
  }) async =>
      await dio.post<T>(
        url,
        queryParameters: queryParameters,
        data: data,
        options: (options ?? Options()).copyWith(
          headers: headers ?? _buildPostHeaders(currentUser.sid ?? ''),
        ),
        cancelToken: cancelToken,
      );

  static Future<Response<T>> get<T>(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        CancelToken? cancelToken,
        Options? options,
      }) =>
      dio.get<T>(
        url,
        queryParameters: queryParameters,
      //   cancelToken: cancelToken,
      //   options: (options ?? Options()).copyWith(
      //     headers: headers ?? _buildPostHeaders(currentUser.sid ?? ''),
      //   ),
      );

  static Map<String, dynamic> _buildPostHeaders(String sid) {
    final Map<String, String> headers = <String, String>{
      'CLOUDID': 'jmu',
      'CLOUD-ID': 'jmu',
      'UAP-SID': sid,
      'WEIBO-API-KEY': Platform.isIOS
          ? Constants.postApiKeyIOS
          : Constants.postApiKeyAndroid,
      'WEIBO-API-SECRET': Platform.isIOS
          ? Constants.postApiSecretIOS
          : Constants.postApiSecretAndroid,
    };
    return headers;
  }

  static BaseOptions get _options {
    return BaseOptions(
      connectTimeout: 20000,
      sendTimeout: 10000,
      receiveTimeout: 10000,
      receiveDataWhenStatusError: true,
      followRedirects: true,
      maxRedirects: 100,
    );
  }

  static HttpClient Function(HttpClient client) get _clientCreate {
    return (HttpClient client) {
      if (_isProxyEnabled) {
        client.findProxy = (_) => _proxyDestination;
      }
      client.badCertificateCallback = (_, __, ___) => true;
      return client;
    };
  }
}
