import 'dart:async';

import 'package:dio/dio.dart';

import '../common/constants.dart';

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
    ProgressCallback? onSendProgress,
  }) async {
    Response<T>? response;
    try {
      response = await dio.post<T>(url,
          queryParameters: queryParameters,
          data: data,
          options: (options ?? Options()).copyWith(
            headers: headers ?? _buildPostHeaders(Singleton().currentUser.token ?? ''),
          ),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress);
      Log.d('request url:$url,\nparam:$queryParameters\nresponse.data:${response.data}');
    } on DioError catch (error) {
      Log.e('request error:$url,\n$queryParameters,\n${error.toString()}');
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
          headers: headers ?? _buildPostHeaders(Singleton().currentUser.token ?? ''),
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
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      receiveDataWhenStatusError: true,
      followRedirects: true,
      maxRedirects: 100,
    );
  }

  // 下载file
  static Future<Response> download<T>({
    required String urlPath,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) =>
      dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
}
