import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/constants.dart';

class NetUtils {
  const NetUtils._();

  static const bool shouldLogRequest = false;

  static final Dio dio = Dio(_options);
  static final Dio tokenDio = Dio(_options);

  static Future<Response<T>?> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    Response<T>? response;
      try{
        response = await dio.post<T>(
          url,
          queryParameters: queryParameters,
          data: data,
          options: (options ?? Options()).copyWith(
            headers:
            headers ?? _buildPostHeaders(Singleton.currentUser.token ?? ''),
          ),
          cancelToken: cancelToken,
        );
        LogUtils.d('request url:$url,\nparam:$queryParameters\nresponse.data:${response.data}');
      }on DioError catch (error) {
         LogUtils.e('request error:$url,\n$queryParameters,');
    }
    return response;
  }

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
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(
          headers:
              headers ?? _buildPostHeaders(Singleton.currentUser.token ?? ''),
        ),
      );

  static Map<String, dynamic> _buildPostHeaders(String token) {
    final Map<String, String> headers = <String, String>{
      'x-access-token': token,
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
}
