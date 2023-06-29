//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-15 18:21:40
//
import 'dart:core';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/version_update_model.dart';

import 'http.dart';

class API {
  const API._();

  /// 资讯
  static Future<dynamic> informationApi(String? type) async {
    return Http.get(ConstUrl.informationApi, params: {'kinds': type});
  }

  /// 登录
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    Map<String, dynamic> param = {'username': username, 'password': password};
    var response = await Http.post(ConstUrl.login, params: param);
    return response;
  }

  /// 第三方登录
  static Future<Map<String, dynamic>?> thirdLogin({
    String? name,
    int? platform,
    String? openId,
    String? icon,
  }) async {
    Map<String, dynamic> param = {'name': name, 'platform': platform, 'openId': openId, 'icon': icon};
    var response = await Http.post(ConstUrl.thirdLogin, params: param);
    return response;
  }

  /// 检查更新
  static Future<Map<String, dynamic>?> checkUpdate(String platform, String version) async {
    Map<String, dynamic> param = {
      'platform': platform,
      'version': version,
    };
    var response = await Http.post(ConstUrl.checkUpdate, params: param);
    return response;
  }

  // 新增版本信息
  static Future<dynamic> addVersionInfo(VersionUpdateModel model) async {
    Map<String, dynamic> param = {
      'id': model.id,
      'platform': model.platform,
      'version': model.version,
      'path': model.path,
      'title': model.title,
      'content': model.content,
      'date': model.date,
    };
    var response = await Http.post("/addVersionInfo", params: param);
    return response;
  }

  // 更新版本信息
  static Future<dynamic> updateVersionInfo(VersionUpdateModel model) async {
    Map<String, dynamic> param = {
      'id': model.id,
      'platform': model.platform,
      'version': model.version,
      'path': model.path,
      'title': model.title,
      'content': model.content,
      'date': model.date,
    };
    var response = await Http.post("/updateVersionInfo", params: param);
    return response;
  }

  // 发布版本更新推送
  static Future<dynamic> versionUpdateNotification(VersionUpdateModel model) async {
    Map<String, dynamic> param = {
      'id': model.id,
      'platform': model.platform,
      'version': model.version,
      'path': model.path,
      'title': model.title,
      'content': model.content,
      'date': model.date,
    };
    var response = await Http.post("/versionUpdateNotification", params: param);
    return response;
  }

  /// 注册推送 userId, 推送id：pushToken, 别名：alias
  static Future<Map<String, dynamic>?> registerNotification(
      {String? userId, String? pushToken, String? alias, String? registrationId, String? identifier}) async {
    Map<String, dynamic> param = {
      'user_id': userId,
      'push_token': pushToken,
      'alias': alias,
      'registration_id': registrationId,
      'identifier': identifier
    };
    var response = await Http.post(ConstUrl.registerNotification, params: param);
    return response;
  }

  /// 发送消息 alias：别名  alert：消息内容
  static Future<Map<String, dynamic>?> sayHello(String alias, String alert) async {
    Map<String, dynamic> param = {
      'alias': alias,
      'alert': alert,
    };
    var response = await Http.post(ConstUrl.sayHello, params: param);
    return response;
  }

  /// 获取消息列表
  static Future<List?> getMessages(String? alias) async {
    Map<String, dynamic> param = {'alias': alias};
    var response = await Http.post(ConstUrl.getMessages, params: param);
    return response;
  }

  //删除消息
  static Future<List?> deleteMessages(String? id) async {
    Map<String, dynamic> param = {'id': id};
    var response = await Http.post(ConstUrl.deleteMessage, params: param);
    return response;
  }

  //删除消息
  static Future<Map<String, dynamic>?> pushDeviceToken(
    String? userid,
    String? deviceToken,
  ) async {
    Map<String, dynamic> param = {'userid': userid, 'deviceToken': deviceToken, 'debug': isDebug};
    var response = await Http.post(ConstUrl.pushDeviceToken, params: param);
    return response;
  }

  /// 添加收藏
  static Future<Map<String, dynamic>?> addFavorite(String content, {String? source}) async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId, 'content': content, 'source': source};
    var response = await Http.post(ConstUrl.addFavorite, params: param);
    return response;
  }

  /// 查询收藏
  static Future<List?> getFavorite() async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId};
    var response = await Http.post(ConstUrl.getFavorite, params: param);
    return response;
  }

  /// 删除收藏
  static Future<List?> deleteFavorite(String favoriteId) async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId, 'favoriteId': favoriteId};
    var response = await Http.post(ConstUrl.deleteFavorite, params: param);
    return response;
  }

  /// 获取反馈
  static Future<dynamic> getFeedback(int pageIndex, int pageSize) async {
    Map<String, dynamic> param = {'userid': Singleton().currentUser.userId, 'page': pageIndex, 'size': pageSize};
    var response = await Http.post(ConstUrl.getFeedback, params: param);
    return response;
  }

  /// 添加反馈
  static Future<dynamic> addFeedback(String content, String? nickname) async {
    Map<String, dynamic> param = {
      'userid': Singleton().currentUser.userId,
      'content': content,
      'nickname': nickname,
      'version': await DeviceUtils.version()
    };
    var response = await Http.post(ConstUrl.addFeedback, params: param);
    return response;
  }

  //插入登录表
  static Future<Map<String, dynamic>?> insertLaunch(Map<String, dynamic>? param) async {
    var response = await Http.post(ConstUrl.insertLaunch, params: param);
    return response;
  }

  /// 获取启动页信息
  static Future<Map<String, dynamic>?> getLaunchInfo({String? date}) async {
    Map<String, dynamic>? param = date == null ? null : {'date': date};
    var response = await Http.get(ConstUrl.getLaunchInfo, params: param);
    return response;
  }

  /// 插入启动页信息
  static Future<Map<String, dynamic>?> insertLaunchInfo(Map<String, dynamic>? param) async {
    var response = await Http.post(ConstUrl.insertLaunchInfo, params: param);
    return response;
  }

  /// 获取设置模块
  static Future<List<dynamic>?> getSettingModule({String? accountType}) async {
    Map<String, dynamic>? param = accountType == null ? null : {'accountType': accountType};
    var response = await Http.get(ConstUrl.getSettingModule, params: param);
    return response;
  }

  /// 获取获取今日提示
  static Future<Map<String, dynamic>?> getTips() async {
    var response = await Http.get(
      ConstUrl.getTips,
    );
    return response;
  }

  /// 获取婚礼代办事件
  static Future<dynamic> getWeddings() async {
    List<dynamic> response = await Http.get('/getWeddings');
    return response;
  }

  /// 插入婚礼代办事件
  static Future<Map<String, dynamic>?> insertWedding({String? title, String? content, int? done}) async {
    Map<String, dynamic> param = {'title': title, 'content': content, 'done': done};
    var response = await Http.post('/insertWedding', params: param);
    return response;
  }

  /// 删除婚礼代办事件
  static Future<Map<String, dynamic>?> deleteWedding(String? id) async {
    Map<String, dynamic> param = {'id': id};
    var response = await Http.post('/deleteWedding', params: param);
    return response;
  }

  /// 更新婚礼代办事件
  static Future<Map<String, dynamic>?> updateWedding({String? id, String? title, String? content, String? done}) async {
    Map<String, dynamic> param = {
      'id': id,
      'title': title,
      'content': content,
      'done': done,
    };
    var response = await Http.post('/updateWedding', params: param);
    return response;
  }

  /// 更新婚礼代办事件排序
  static Future<Map<String, dynamic>?> updateWeddingSort({required String? id, required int sort}) async {
    Map<String, dynamic> param = {
      'id': id,
      'sort': sort,
    };
    var response = await Http.post('/updateWeddingSort', params: param);
    return response;
  }

  /// 获取登录信息
  static Future<List<dynamic>> getLogins(int page, int size) async {
    Map<String, dynamic> params = {"page": page, "size": size};
    List<dynamic> response = await Http.get('/getLogins', params: params);
    return response;
  }

  /// 上传文件
  static uploadFile({required String path, String? fileName, ValueChanged<double>? onSendProgress}) async {
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
      print('a=$a,b=$b');
      double s = double.parse(a.toString()) / double.parse(b.toString());
      onSendProgress?.call(s);
    });
  }

  /// 上传文件
  static uploadFileWithBytes(
      {required Uint8List bytes,
      String? fileName,
      String? type = 'launchImage',
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
    });
  }

  static const String _secret = 'lalalala';

  /// 获取文件
  static Future<List<dynamic>?> getFiles(String? catalog) async {
    Map<String, dynamic>? params = {"secret": _secret, 'catalog': catalog};
    if (catalog == null || catalog == '') {
      params.remove('catalog');
    }
    List<dynamic>? response = await Http.get(
      '/getFiles',
      params: params,
    );
    return response;
  }

  static Future<dynamic> downloadFile(
      {required String url,
      required String savePath,
      void Function(int, int, double)? onReceiveProgress,
      CancelToken? cancelToken}) async {
    return Http.downloadFile(
        url: url, savePath: savePath, onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);
  }

  /// 更改文件/文件夹名称
  static Future<dynamic> changeFileName(String? catalog, String oldName, String newName) async {
    Map<String, dynamic>? params = {
      "secret": _secret,
      'path': catalog,
      'oldName': oldName,
      'newName': newName,
    };
    List<dynamic>? response = await Http.post(
      '/changeFileName',
      params: params,
    );
    return response;
  }

  /// 删除文件/文件夹
  static Future<dynamic> deleteFile(String? path, String name) async {
    Map<String, dynamic>? params = {"secret": _secret, 'path': path, 'name': name};
    var response = await Http.post(
      '/deleteFile',
      params: params,
    );
    return response;
  }

  /// 获取图片
  static Future<dynamic> getImages(String? catalog) async {
    List<dynamic>? response = await Http.get(
      '/images',
      params: {"catalog": catalog.objectIsEmpty() ? '' : "/$catalog/"},
    );
    return response;
  }

  static Future<String> loadTips() async {
    var response = await Http.get(ConstUrl.informationApi, params: {'kinds': InformationType.saylove});
    return response['newslist'].first['content'];
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
}

class ConstUrl {
  ConstUrl._();

  ///登录
  static const String login = '/login';

  ///第三方登录
  static const String thirdLogin = '/thirdLogin';

  ///注册推送
  static const String registerNotification = '/registerNotification';

  ///发送消息
  static const String sayHello = '/sayHello';

  ///检查更新
  static const String checkUpdate = '/checkUpdate';

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

  ///添加反馈
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

  ///获取每日提示
  static const String getTips = '/getTips';

  ///添加登录信息
  static const String insertLaunch = '/insertLaunch';

  ///添加登录信息
  static const String pushDeviceToken = '/pushDeviceToken';

  /// 资讯
  static const String informationApi = '/informationApi';
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
