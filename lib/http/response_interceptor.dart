//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-03-09 16:44:37
//
part of 'interceptors.dart';

class ResponseInterceptor extends Interceptor {
  ResponseInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.n(options.uri, tag: 'url');
    Log.n(options.data, tag: 'data');
    Log.n(options.queryParameters, tag: 'queryParameters');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    EasyLoading.dismiss();
    Log.n(response.data, tag: 'response');
    if (response.statusCode == 200) {
      if (response.data is Map) {
        int code = response.data['code'];
        if (code == 200) {
          if (response.data['data'] != null) {
            response.data = response.data['data'];
          }
        } else if (code == 600) {
          // 登录超时，跳转登录页面
          return;
        } else {
          showToast(response.data['msg']);
          return;
        }
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.e('onError: ${err.message}');
    _dioError(err);
    showToast('request error');
    EasyLoading.dismiss();
    super.onError(err, handler);
  }

  // 处理 Dio 异常
  static String _dioError(DioError error) {
    String message;
    switch (error.type) {
      case DioErrorType.connectTimeout:
        message = "网络连接超时，请检查网络设置";
        break;
      case DioErrorType.receiveTimeout:
        message = "服务器异常，请稍后重试！";
        break;
      case DioErrorType.sendTimeout:
        message = "网络连接超时，请检查网络设置";
        break;
      case DioErrorType.response:
        message = "服务器异常，请稍后重试！";
        break;
      case DioErrorType.cancel:
        message = "请求已被取消，请重新请求";
        break;
      case DioErrorType.other:
        message = "网络异常，请稍后重试！";
        break;
      default:
        message = "Dio异常";
    }
    return message;
  }

  // 处理 Http 错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    EasyLoading.showError(message);
  }
}
