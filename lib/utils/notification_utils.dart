///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2019-12-13 14:11
///
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:nothing/page/message_page.dart';

import '../constants/constants.dart' hide Message;

class NotificationUtils {
  static final JPush jpush = JPush();

  //极光推送初始化
  static Future<JPush> jPushInit() async {
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: ${message}");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: ${message}");
        if (globalContext?.widget.toString() != 'MessagePage') {
          BuildContext context = navigatorState.overlay!.context;
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const MessagePage()));
        }
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );

    jpush.setup(
      appKey: "713db5486c35b95a967e3b3a",
      channel: "theChannel",
      production: isDebug,
      debug: false, // 设置是否打印 debug 日志
    );

    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    jpush.setBadge(0);

    //设置别名
    var result = await setAlias(Singleton.currentUser.username);
    print('setAlias = $result');
    return jpush;
  }

  static Future<String?> setAlias(String? alias,{bool mustset = false}) async {
    if (alias == null || alias == '') return null;
    if (! await Constants.isPhysicalDevice()) return null;

    //若本地有，表明设置成功过，无需再设置
    String? localAlias = await LocalDataUtils.get(KEY_ALIAS);
    print('localAlias=$localAlias');
    if(mustset == false){
      if (localAlias != null ) return localAlias;
    }
    try {
      String result = '';
      for (int i = 0; i < alias.length; i++) {
        String c = alias[i];
        if (RegExp('[0-9a-zA-z]').hasMatch(c)) result = result + c;
      }
      alias = result;
    } catch (error) {}

    if (alias == null || alias.isEmpty) {
      alias = 'all';
    }

    try {
      await jpush.setAlias(alias);
      // 设置成功，保存本地
      await LocalDataUtils.setString(KEY_ALIAS, alias);
      // 注册服务器
      var userId = Singleton.currentUser.userId;
      var registrationId = await jpush.getRegistrationID();
      String? identifierForVendor = Singleton.currentUser.openId;
      UserAPI.registerNotification(
          userId: userId,
          pushToken: null,
          alias: alias,
          registrationId: registrationId,
          identifier: identifierForVendor);
    } catch (error) {}
    return alias;
  }

  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static void initSettings() {
    const AndroidInitializationSettings _settingsAndroid =
        AndroidInitializationSettings('ic_stat_name');
    const IOSInitializationSettings _settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: _onReceive,
    );
    const InitializationSettings _settings = InitializationSettings(
      android: _settingsAndroid,
      iOS: _settingsIOS,
    );
    NotificationUtils.plugin.initialize(
      _settings,
      onSelectNotification: _onSelect,
    );
  }

  static Future<void> show(String title, String body) async {
    final Color color = currentThemeColor;
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'openjmu_message_channel',
      '推送消息',
      channelDescription: '通知接收到的消息',
      importance: Importance.high,
      priority: Priority.high,
      color: color,
      ticker: 'ticker',
    );
    const IOSNotificationDetails iOSDetails = IOSNotificationDetails();
    final NotificationDetails _details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    await NotificationUtils.plugin.show(0, title, body, _details);
  }

  // static Future<void> showAppMessage(
  //   WebApp app,
  //   String body,
  // ) async {
  //   final Color color = currentThemeColor;
  //   final WebAppIcon icon = WebAppIcon(app: app);
  //   final Person p = Person(
  //     name: app.name,
  //     key: app.appId.toString(),
  //     icon: await icon.exist
  //         ? FlutterBitmapAssetAndroidIcon(icon.iconPath)
  //         : null,
  //   );
  //   final List<Message> messages = <Message>[Message(body, DateTime.now(), p)];
  //   final MessagingStyleInformation messagingStyle = MessagingStyleInformation(
  //     p,
  //     conversationTitle: app.name,
  //     groupConversation: false,
  //     messages: messages,
  //   );
  //   final AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'openjmu_message_channel',
  //     '推送消息',
  //     channelDescription: '通知接收到的消息',
  //     category: 'msg',
  //     color: color,
  //     importance: Importance.high,
  //     priority: Priority.high,
  //     ticker: app.name,
  //     styleInformation: messagingStyle,
  //   );
  //   final NotificationDetails _details = NotificationDetails(
  //     android: androidDetails,
  //     iOS: const IOSNotificationDetails(),
  //   );
  //   await NotificationUtils.plugin.show(0, app.name, body, _details);
  // }

  static Future<void> cancelAll() {
    return NotificationUtils.plugin.cancelAll();
  }

  static Future<void> _onReceive(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {}

  static Future<void> _onSelect(String? payload) async {
    if (payload != null) {
      LogUtils.d('notification payload: ' + payload);
    }
  }
}
