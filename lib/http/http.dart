//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-03-09 17:44:59
//
import 'package:dio/dio.dart';
import 'package:nothing/constants/constants.dart';
import 'api.dart';
import 'interceptors.dart';

class Http {
  static final BaseOptions _options = BaseOptions(

      ///Api地址
      baseUrl: ConstUrl.baseUrl,

      ///打开超时时间
      connectTimeout: 20000,

      ///接收超时时间
      receiveTimeout: 30000,

      //是否不使用缓存
      extra: {
        'refresh': true
      },
      //请求头
      headers: {
        'Accept-Language':
            Constants.isChinese ? 'zh-CN,zh;q=0.9' : 'en-US,en;q=0.9'
      });

  // 创建 Dio 实例
  static final Dio _dio = Dio(_options)
    ..interceptors.add(CacheInterceptor())
    ..interceptors.add(ResponseInterceptor());

  // _request所有的请求都会走这里
  static Future<T> _request<T>(String path,
      {String method = 'GET',
      Map<String, dynamic>? params,
      dynamic data,
      ProgressCallback? onSendProgress}) async {
    try {
      _dio.options.method = method;
      _dio.options.headers['AuthToken'] = Singleton.currentUser.token;
      Response response = await _dio.request(path,
          data: data, queryParameters: params, onSendProgress: onSendProgress);
      return response.data;
    } catch (error) {
      return Future.error(error);
    }
  }

  static Future<T> get<T>(String path, {Map<String, dynamic>? params}) {
    return _request(path, method: 'GET', params: params);
  }

  static Future<T> post<T>(String path,
      {Map<String, dynamic>? params, data, ProgressCallback? onSendProgress}) {
    return _request(path,
        method: 'POST',
        params: params,
        data: data,
        onSendProgress: onSendProgress);
  }

  static Future<Object?> uploadFile<T>(String url,
      {dynamic data, ProgressCallback? onSendProgress}) {
    _dio.options.headers['AuthToken'] = Singleton.currentUser.token;
    return _dio.post(url, data: data, onSendProgress: onSendProgress);
  }
}
