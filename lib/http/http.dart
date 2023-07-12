//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-03-09 17:44:59
//
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nothing/common/app_routes.dart';
import 'package:nothing/common/constants.dart';
import 'package:nothing/model/error_model.dart';

import '../config.dart';
import 'interceptors.dart';

class Http {
  static final BaseOptions _options = BaseOptions(

      //Api地址
      baseUrl: Config.baseUrl,

      //打开超时时间
      connectTimeout: const Duration(seconds: 20),

      //接收超时时间
      receiveTimeout: const Duration(seconds: 30),

      //是否不使用缓存
      extra: {
        'refresh': true
      },
      //请求头
      headers: {
        'Accept-Language': Constants.isChinese ? 'zh-CN,zh;q=0.9' : 'en-US,en;q=0.9',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*'
      });

  // 创建 Dio 实例
  static final Dio _dio = Dio(_options)
    ..interceptors.add(CacheInterceptor())
    ..interceptors.add(ResponseInterceptor());

  static Future<AppResponse> get(String path,
      {Map<String, dynamic>? params, bool needLoading = true, bool needErrorToast = true}) {
    return _request(path, method: 'GET', params: params, needLoading: needLoading, needErrorToast: needErrorToast);
  }

  static Future<AppResponse> post<T>(String path,
      {Map<String, dynamic>? params,
      data,
      ProgressCallback? onSendProgress,
      bool needLoading = true,
      bool needErrorToast = true}) {
    return _request(path,
        method: 'POST',
        params: params,
        data: data,
        onSendProgress: onSendProgress,
        needLoading: needLoading,
        needErrorToast: needErrorToast);
  }

  static Future<AppResponse> uploadFile<T>(String path,
      {Map<String, dynamic>? data,
      ProgressCallback? onSendProgress,
      bool needLoading = true,
      bool needErrorToast = true}) {
    return _request(path,
        method: 'POST',
        data: data,
        onSendProgress: onSendProgress,
        needLoading: needLoading,
        needErrorToast: needErrorToast);
  }

  // _request所有的请求都会走这里
  static Future<AppResponse> _request<T>(String path,
      {String method = 'GET',
      Map<String, dynamic>? params,
      dynamic data,
      ProgressCallback? onSendProgress,
      CancelToken? cancelToken,
      bool needLoading = true,
      bool needErrorToast = true}) async {
    late AppResponse httpResponse;
    if (needLoading) showLoading();
    try {
      _dio.options.method = method;
      _dio.options.headers['Authorization'] = Handler.accessToken;
      Response response = await _dio.request(path,
          data: data, queryParameters: params, onSendProgress: onSendProgress, cancelToken: cancelToken);
      httpResponse = response.data;
      if (!httpResponse.isSuccess) {
        if (httpResponse.code == AppResponseCode.tokenError) {
          if (Handler.isLogin) {
            Handler.logout();
            await Future.delayed(const Duration(milliseconds: 300));
            await AppRoute.popUntil(routeName: AppRoute.login.name);
          }
        }
        if (needErrorToast) {
          showToast(httpResponse.msg ?? '服务器开小差了');
        }
      }
    } on DioError catch (error) {
      httpResponse = AppResponse(
        code: AppResponseCode.networkError,
        error: ErrorModel()..message = error.toString(),
      );
      showToast('网络繁忙');
    }
    if (needLoading) hideLoading();
    return httpResponse;
  }

  static Future<AppResponse> downloadFile(
      {required String url,
      required String savePath,
      void Function(int, int, double)? onReceiveProgress,
      CancelToken? cancelToken,
      bool needLoading = false}) async {
    if (needLoading) showLoading();
    late AppResponse httpResponse;

    try {
      Dio dio = Dio();
      dio.options.headers['Authorization'] = Handler.accessToken;
      dio.options.headers[HttpHeaders.acceptEncodingHeader] = "*";
      Response response = await dio.download(
        url,
        savePath,
        // options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            double percent = (receivedBytes / totalBytes);
            onReceiveProgress?.call(receivedBytes, totalBytes, percent);
          } else {
            onReceiveProgress?.call(receivedBytes, totalBytes, -1);
          }
        },
        cancelToken: cancelToken,
        deleteOnError: false,
      );
      httpResponse = response.data;
    } catch (error) {
      httpResponse = AppResponse(
        code: AppResponseCode.networkError,
        error: ErrorModel()..message = error.toString(),
      );

      if (httpResponse.code == AppResponseCode.tokenError) {
        if (Handler.isLogin) {
          Handler.logout();
          await Future.delayed(const Duration(milliseconds: 300));
          await AppRoute.popUntil(routeName: AppRoute.login.name);
        }
      }

      showToast('网络繁忙');
    }
    if (needLoading) hideLoading();
    return httpResponse;
  }
}

class AppResponseCode {
  static const int normal = 0;
  static const int networkError = -1;
  static const int serverError = 500;
  static const int fileError = -3;
  static const int tokenError = 401;
}

class AppResponse {
  int? code;
  Object? data;
  ErrorModel? error;
  String? msg;

  Map<String, dynamic> get dataMap {
    if (data is Map) {
      return data as Map<String, dynamic>;
    }
    return {};
  }

  List<dynamic> get dataList {
    if (data is List) {
      return data as List;
    }
    return [];
  }

  String get dataString {
    if (data is String) {
      return data as String;
    }
    return '';
  }

  bool get isSuccess => code == AppResponseCode.normal;

  AppResponse({this.code, this.data, this.error, this.msg});
}

class Handler {
  static String? get accessToken {
    String? token = HiveBoxes.get(HiveKey.accessToken);
    if (token != null) {
      token = 'Bearer $token';
    }
    return token;
  }

  static set accessToken(String? token) {
    if ('Bearer $token' != Handler.accessToken) {
      HiveBoxes.put(HiveKey.accessToken, token);
    }
  }

  static bool get isLogin {
    return HiveBoxes.get(HiveKey.accessToken) != null;
  }

  static void logout() {
    HiveBoxes.clear();
    Singleton().currentUser = UserInfoModel();
  }
}
