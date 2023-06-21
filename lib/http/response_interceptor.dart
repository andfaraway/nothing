//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-03-09 16:44:37
//
part of 'interceptors.dart';

class ResponseInterceptor extends Interceptor {
  ResponseInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.n(options.uri, tag: 'request - ${options.method}');
    Log.n(options.queryParameters, tag: 'queryParameters');
    Log.n(options.data, tag: 'data');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.n(response.data, tag: 'response - ${response.requestOptions.path}');
    if (response.statusCode == 200 && response.data is Map) {
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
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.n('${err.requestOptions.path}=>${err.type}', tag: 'error ❌');
    super.onError(err, handler);
  }
}
