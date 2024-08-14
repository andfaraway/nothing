//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-15 18:21:40
//
import 'dart:core';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/poetry_model.dart';
import 'package:nothing/model/version_update_model.dart';

class API {
  const API._();

  /// 登录
  static Future<AppResponse> login({required String username, required String password}) async {
    Map<String, dynamic> param = {'username': username, 'password': password.getMd5()};
    return Http.post(ConstUrl.login, params: param, needErrorToast: false);
  }

  /// 第三方登录
  static Future<AppResponse> thirdLogin({
    String? name,
    int? platform,
    String? openId,
    String? icon,
  }) async {
    Map<String, dynamic> param = {'name': name, 'platform': platform, 'openId': openId, 'icon': icon};
    return Http.post(ConstUrl.thirdLogin, params: param);
  }

  /// 获取用户信息
  static Future<AppResponse> getUserInfo() {
    return Http.get(ConstUrl.getUserInfo, needLoading: false);
  }

  /// 刷新token
  static Future<bool> refreshToken() async {
    if (!Handler.isLogin) return false;
    if (HiveBoxes.get(HiveKey.refreshDate) == Constants.nowString) return false;

    AppResponse response = await Http.get(ConstUrl.refreshToken, needLoading: false, refresh: true);
    if (response.isSuccess) {
      Handler.accessToken = response.dataMap['access_token'];
      HiveBoxes.put(HiveKey.refreshDate, Constants.nowString);
      return true;
    } else {
      return false;
    }
  }

  /// 检查更新
  static Future<AppResponse> checkUpdate({bool needLoading = false}) async {
    if (Constants.isWeb) {
      return AppResponse()..code = AppResponseCode.serverError;
    }
    Map<String, dynamic> param = {
      'platform': Constants.platform,
      'version': DeviceUtils.deviceInfo.package.version,
    };
    return Http.post(ConstUrl.checkUpdate, params: param, needLoading: needLoading);
  }

  // 新增版本信息
  static Future<AppResponse> addVersionInfo(VersionUpdateModel model) async {
    Map<String, dynamic> param = {
      'id': model.id,
      'platform': model.platform,
      'version': model.version,
      'path': model.path,
      'title': model.title,
      'content': model.content,
      'date': model.date,
    };
    return Http.post(ConstUrl.addVersionInfo, params: param);
  }

  // 更新版本信息
  static Future<AppResponse> updateVersionInfo(VersionUpdateModel model) async {
    Map<String, dynamic> param = {
      'id': model.id,
      'platform': model.platform,
      'version': model.version,
      'path': model.path,
      'title': model.title,
      'content': model.content,
      'date': model.date,
    };
    return Http.post(ConstUrl.updateVersionInfo, params: param);
  }

  // 发布版本更新推送
  static Future<AppResponse> versionUpdateNotification(VersionUpdateModel model) async {
    Map<String, dynamic> param = {
      'id': model.id,
      'platform': model.platform,
      'version': model.version,
      'path': model.path,
      'title': model.title,
      'content': model.content,
      'date': model.date,
    };
    return Http.post(ConstUrl.sendVersionUpdateNotification, params: param);
  }

  /// 资讯
  static Future<AppResponse> informationApi(String? type) async {
    return Http.get(ConstUrl.informationApi, params: {'kinds': type}, needLoading: false);
  }

  /// 获取通用信息
  static Future<AppResponse> getCommonInfo({String? table, int? pageIndex, int? pageSize}) async {
    Map<String, dynamic> params = {"table": table, "page": pageIndex, "size": pageSize};
    return Http.get(ConstUrl.getCommonInfo, params: params);
  }

  /// 获取颜色models
  static Future<AppResponse> getColorModels() async {
    return Http.get(ConstUrl.getColorModels);
  }

  /// 获取推荐颜色
  static Future<AppResponse> getBeautifulColors({String model = 'default', List<String> colors = const []}) async {
    Map<String, dynamic> params = {"model": model, "colors": colors}.removeEmptyValue();
    return Http.get(ConstUrl.getBeautifulColors, params: params);
  }

  /// 注册推送 userId, 推送id：pushToken, 别名：alias
  static Future<AppResponse> registerNotification(
      {String? userId, String? pushToken, String? alias, String? registrationId, String? identifier}) async {
    Map<String, dynamic> param = {
      'user_id': userId,
      'push_token': pushToken,
      'alias': alias,
      'registration_id': registrationId,
      'identifier': identifier
    };
    return Http.post(ConstUrl.registerNotification, params: param);
  }

  /// 发送消息 alias：别名  alert：消息内容
  static Future<AppResponse> sayHello(String alias, String alert) async {
    Map<String, dynamic> param = {
      'alias': alias,
      'alert': alert,
    };
    return Http.post(ConstUrl.sayHello, params: param);
  }

  /// 获取消息列表
  static Future<AppResponse> getMessages({String? alias, int pageNum = 0, int pageSize = 10}) async {
    Map<String, dynamic> param = {'alias': alias, 'pageNum': pageNum, 'pageSize': pageSize};
    return Http.post(ConstUrl.getMessages, params: param);
  }

  /// 删除消息
  static Future<AppResponse> deleteMessages(String? id) async {
    Map<String, dynamic> param = {'id': id};
    return Http.post(ConstUrl.deleteMessage, params: param);
  }

  /// 推送deviceToken
  static Future<AppResponse> pushDeviceToken(
    String? userid,
    String? deviceToken,
  ) async {
    Map<String, dynamic> param = {'userid': userid, 'deviceToken': deviceToken, 'debug': isDebug};
    return Http.post(ConstUrl.pushDeviceToken, params: param);
  }

  /// 添加收藏
  static Future<AppResponse> addFavorite(String content, {String? source}) async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId, 'content': content, 'source': source};
    return Http.post(ConstUrl.addFavorite, params: param);
  }

  /// 查询收藏
  static Future<AppResponse> getFavorite() async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId};
    return Http.post(ConstUrl.getFavorite, params: param);
  }

  /// 删除收藏
  static Future<AppResponse> deleteFavorite(String favoriteId) async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId, 'favoriteId': favoriteId};
    return Http.post(ConstUrl.deleteFavorite, params: param);
  }

  /// 获取反馈
  static Future<AppResponse> getFeedback(int pageIndex, int pageSize) async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId, 'page': pageIndex, 'size': pageSize};
    return Http.get(ConstUrl.getFeedback, params: param);
  }

  /// 添加反馈
  static Future<AppResponse> addFeedback(String content, String? nickname) async {
    Map<String, dynamic> param = {
      'userid': Singleton().currentUser.userId,
      'content': content,
      'nickname': nickname,
      'version': DeviceUtils.deviceInfo.package.version
    };
    return Http.post(ConstUrl.addFeedback, params: param);
  }

  /// 插入登录表
  static Future<AppResponse> insertLaunch() async {
    if (Constants.isWeb) return AppResponse();
    if (!DeviceUtils.deviceInfo.device.info.isPhysicalDevice) return AppResponse();

    Map<String, dynamic> param = {};
    param['userid'] = Singleton().currentUser.userId;
    param['username'] = Singleton().currentUser.username;
    //推送别名
    param['alias'] = HiveBoxes.get(HiveKey.pushAlias);
    await DeviceUtils.refreshRuntimeInfo();
    //推送注册id
    param['registrationID'] = DeviceUtils.deviceInfo.runtime.deviceToken;
    param['battery'] = DeviceUtils.deviceInfo.runtime.battery;
    param['network'] = DeviceUtils.deviceInfo.runtime.network;
    param['device_info'] = DeviceUtils.deviceInfo.device.info.deviceInfo;

    return Http.post(ConstUrl.insertLaunch, params: param);
  }

  /// 获取启动页信息
  static Future<AppResponse> getLaunchInfo({String? date}) async {
    Map<String, dynamic>? param = date == null ? null : {'date': date};
    return Http.get(ConstUrl.getLaunchInfo, params: param, needLoading: false);
  }

  /// 插入启动页信息
  static Future<AppResponse> insertLaunchInfo(Map<String, dynamic>? param) async {
    return Http.post(ConstUrl.insertLaunchInfo, params: param);
  }

  /// 获取设置模块
  static Future<AppResponse> getSettingModule({String? accountType}) async {
    Map<String, dynamic>? param = accountType == null ? null : {'accountType': accountType};
    return Http.get(ConstUrl.getSettingModule, params: param, needLoading: false);
  }

  /// 获取获取今日提示
  static Future<AppResponse> getTips() async {
    return Http.get(ConstUrl.getTips, needLoading: false);
  }

  /// 获取婚礼代办事件
  static Future<AppResponse> getWeddings() async {
    return Http.get(ConstUrl.getWeddings);
  }

  /// 插入婚礼代办事件
  static Future<AppResponse> insertWedding({String? title, String? content, int? done}) async {
    Map<String, dynamic> param = {'title': title, 'content': content, 'done': done};
    return Http.post(ConstUrl.insertWedding, params: param);
  }

  /// 删除婚礼代办事件
  static Future<AppResponse> deleteWedding(String? id) async {
    Map<String, dynamic> param = {'id': id};
    return Http.post(ConstUrl.deleteWedding, params: param);
  }

  /// 更新婚礼代办事件
  static Future<AppResponse> updateWedding({String? id, String? title, String? content, String? done}) async {
    Map<String, dynamic> param = {
      'id': id,
      'title': title,
      'content': content,
      'done': done,
    };
    return Http.post(ConstUrl.updateWedding, params: param);
  }

  /// 更新婚礼代办事件排序
  static Future<AppResponse> updateWeddingSort({required String? id, required int sort}) async {
    Map<String, dynamic> param = {
      'id': id,
      'sort': sort,
    };
    return Http.post(ConstUrl.updateWeddingSort, params: param);
  }

  /// 获取登录信息
  static Future<AppResponse> getLogins(int page, int size) async {
    Map<String, dynamic> params = {"page": page, "size": size};
    return await Http.get(ConstUrl.getLogins, params: params);
  }

  /// 上传文件
  static Future<AppResponse> uploadFile(
      {required String path, String? fileName, ValueChanged<double>? onSendProgress}) async {
    List list = path.split('.');
    String houzhui = list.last;
    if (houzhui.length == 1) {
      houzhui = 'jpg';
    }
    fileName ??= path.split('/').last;

    MultipartFile f = await MultipartFile.fromFile(path, filename: fileName);
    FormData formData = FormData.fromMap({
      'file': f,
      //传参信息
      "type": 'launchImage',
      "name": fileName
    });

    return Http.post(ConstUrl.uploadFile, data: formData, onSendProgress: (a, b) {
      double s = double.parse(a.toString()) / double.parse(b.toString());
      onSendProgress?.call(s);
    });
  }

  /// 图片压缩
  static Future<AppResponse> imageCompress(
      {required Uint8List bytes,
      String? fileName,
      String? type = 'imageCompress',
      int quality = 70,
      ValueChanged<double>? onSendProgress}) async {
    MultipartFile f = MultipartFile.fromBytes(bytes, filename: fileName);
    FormData formData = FormData.fromMap({
      'file': f,
      //传参信息
      "type": type,
      "quality": quality,
      "fileName": fileName
    });

    return Http.post(ConstUrl.imageCompress, data: formData, onSendProgress: (a, b) {
      double s = double.parse(a.toString()) / double.parse(b.toString());
      onSendProgress?.call(s);
    }, needLoading: false);
  }

  static const String _secret = 'lalalala';

  /// 获取文件
  static Future<AppResponse> getFiles(String? catalog) async {
    Map<String, dynamic>? params = {"secret": _secret, 'catalog': catalog};
    if (catalog == null || catalog == '') {
      params.remove('catalog');
    }
    return await Http.get(
      ConstUrl.getFiles,
      params: params,
    );
  }

  static Future<AppResponse> downloadFile(
      {required String url,
      required String savePath,
      void Function(int, int, double)? onReceiveProgress,
      CancelToken? cancelToken}) async {
    return Http.downloadFile(
        url: url, savePath: savePath, onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);
  }

  /// 更改文件/文件夹名称
  static Future<AppResponse> changeFileName(String? catalog, String oldName, String newName) async {
    Map<String, dynamic>? params = {
      "secret": _secret,
      'path': catalog,
      'oldName': oldName,
      'newName': newName,
    };
    return await Http.post(
      ConstUrl.changeFileName,
      params: params,
    );
  }

  /// 删除文件/文件夹
  static Future<AppResponse> deleteFile(String? path, String name) async {
    Map<String, dynamic>? params = {"secret": _secret, 'path': path, 'name': name};
    return Http.post(
      ConstUrl.deleteFile,
      params: params,
    );
  }

  /// 获取图片
  static Future<AppResponse> getImages(String? catalog) async {
    return Http.get(
      '/images',
      params: {"catalog": catalog.objectIsEmpty() ? '' : "/$catalog/"},
    );
  }

  /// 土味情话
  static Future<AppResponse> getLoveTips() async {
    return Http.get(ConstUrl.informationApi, params: {'kinds': InformationType.saylove}, needLoading: false);
  }

  static Future<bool> launchWeb({
    required String url,
    String? title,
    bool withCookie = true,
  }) async {
    final SettingsProvider provider = Provider.of<SettingsProvider>(
      currentContext,
      listen: false,
    );
    final bool shouldLaunchFromSystem = provider.launchFromSystemBrowser;
    if (shouldLaunchFromSystem) {
      Log.d('Launching web: $url');
      return launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      Log.d('Launching web: $url');
      AppRoute.pushNamePage(null, AppRoute.webView.name, arguments: url);
      return true;
    }
  }

  /// 获取诗歌
  static Future<AppResponse> getPoetry(
      {String? keyword, PoetryModel? model, int pageNum = 0, int pageSize = 10}) async {
    keyword = keyword?.trim();
    Map<String, dynamic> params = model?.toJson() ?? {};
    params.addAll({"pageNum": pageNum, "pageSize": pageSize, 'keyword': keyword}.removeEmptyValue());
    return Http.get(
      ConstUrl.getPoetry,
      params: params.removeEmptyValue(),
    );
  }

  /// 上报异常
  static Future<AppResponse> exceptionReport(Map<String, dynamic> data) async {
    return Http.post(ConstUrl.exceptionReport, data: data.removeEmptyValue());
  }

  /// 获取异常
  static Future<AppResponse> getExceptions(int pageIndex, int pageSize) async {
    Map<String, dynamic> param = {'page': pageIndex, 'size': pageSize};
    return Http.get(ConstUrl.getExceptions, params: param);
  }
}

class ConstUrl {
  ConstUrl._();

  ///登录
  static const String login = '/login';

  ///刷新token
  static const String refreshToken = '/refreshToken';

  ///第三方登录
  static const String thirdLogin = '/thirdLogin';

  ///获取用户信息
  static const String getUserInfo = '/getUserInfo';

  ///检查更新
  static const String checkUpdate = '/checkUpdate';

  ///添加版本更新信息
  static const String addVersionInfo = '/addVersionInfo';

  ///添加版本更新信息
  static const String updateVersionInfo = '/updateVersionInfo';

  ///发送版本更新通知
  static const String sendVersionUpdateNotification = '/versionUpdateNotification';

  ///注册推送
  static const String registerNotification = '/registerNotification';

  ///发送消息
  static const String sayHello = '/sayHello';

  ///获取消息列表
  static const String getMessages = '/getMessages';

  ///删除消息
  static const String deleteMessage = '/deleteMessage';

  ///添加收藏
  static const String addFavorite = '/addFavorite';

  ///查询收藏
  static const String getFavorite = '/getFavorite';

  ///删除收藏
  static const String deleteFavorite = '/deleteFavorite';

  ///获取反馈
  static const String getFeedback = '/getFeedback';

  ///添加反馈
  static const String addFeedback = '/addFeedback';

  ///获取启动页信息
  static const String getLaunchInfo = '/getLaunchInfo';

  ///插入启动页信息
  static const String insertLaunchInfo = '/insertLaunchInfo';

  ///获取设置模块
  static const String getSettingModule = '/getSettingModule';

  ///上传文件
  static const String uploadFile = '/uploadFile';

  ///压缩图片
  static const String imageCompress = '/imageCompress';

  /// 获取文件
  static const String getFiles = '/getFiles';

  /// 更改文件名称
  static const String changeFileName = '/changeFileName';

  /// 删除文件/文件夹
  static const String deleteFile = '/deleteFile';

  ///获取每日提示
  static const String getTips = '/getTips';

  /// 获取婚礼代办
  static const String getWeddings = '/getWeddings';

  /// 插入婚礼代办
  static const String insertWedding = '/insertWedding';

  /// 删除婚礼代办
  static const String deleteWedding = '/deleteWedding';

  /// 更新婚礼代办
  static const String updateWedding = '/updateWedding';

  /// 更新婚礼代办排序
  static const String updateWeddingSort = '/updateWeddingSort';

  /// 获取登录信息
  static const String getLogins = '/getLogins';

  ///添加登录信息
  static const String insertLaunch = '/insertLaunch';

  ///添加登录信息
  static const String pushDeviceToken = '/pushDeviceToken';

  /// 资讯
  static const String informationApi = '/informationApi';

  /// 获取通用信息
  static const String getCommonInfo = '/getCommonInfo';

  /// 获取颜色models
  static const String getColorModels = '/getColorModels';

  /// 获取推荐颜色
  static const String getBeautifulColors = '/getBeautifulColors';

  /// 获取诗歌
  static const String getPoetry = '/getPoetry';

  /// 上报错误
  static const String exceptionReport = '/exceptionReport';

  /// 获取异常信息
  static const String getExceptions = '/getExceptions';
}

class InformationType {
  const InformationType._();

  /// 生活小窍门
  static const String qiaomen = 'qiaomen';

  ///健康提示
  static const String healthtip = 'healthtip';

  ///彩虹屁
  static const String caihongpi = 'caihongpi';

  ///中国老黄历
  static const String lunar = 'lunar';

  /// 头条
  static const String topNews = 'topNews';

  ///土味情话
  static const String saylove = 'saylove';
}
