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
    dynamic data = response.data;
    AppResponse httpResponse = AppResponse(code: AppResponseCode.serverError);

    if (response.statusCode == 200 && response.data is Map) {
      Map receiveData = data;
      int code = int.tryParse('${receiveData['code']}') ?? 0;
      httpResponse.code = code;
      httpResponse.data = receiveData['data'];
      if (code != AppResponseCode.normal) {
        dynamic error = receiveData['error'];
        if (error is Map<String, dynamic>) {
          httpResponse.error = ErrorModel.fromJson(error);
        }
      }
    }

    if (httpResponse.code == AppResponseCode.serverError) {
      httpResponse.error = ErrorModel()
        ..code = data['code']
        ..message = '请求失败';
    }

    response.data = httpResponse;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.n('${err.requestOptions.path}=>${err.type}', tag: 'error ❌');
    super.onError(err, handler);
  }
}
