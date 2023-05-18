//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-03-09 12:01:38
//
part of 'interceptors.dart';

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  final _cache = <Uri, Response>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var response = _cache[options.uri];
    if (options.extra['refresh'] == true) {
      return handler.next(options);
    } else if (response != null) {
      LogUtils.n('${options.uri}', tag: 'cache');
      return handler.resolve(response);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }
}
