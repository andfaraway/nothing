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

import '../constants/constants.dart' hide Message;

class NotificationUtils {
  const NotificationUtils._();

  //极光推送初始化
  static jPushInit() async {
    final JPush jpush = JPush();

    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );

    jpush.setup(
      appKey: "713db5486c35b95a967e3b3a",
      channel: "theChannel",
      production: false,
      debug: false, // 设置是否打印 debug 日志
    );

    jpush.applyPushAuthority(
        const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    String? alias = Singleton.currentUser.name;
    if (Singleton.currentUser.name != null) {
      try {
        if (alias != null) {
          String result = '';
          for (int i = 0; i < alias.length; i++) {
            String c = alias[i];
            if (RegExp('[0-9a-zA-z]').hasMatch(c)) result = result + c;
          }
          alias = result;
        }
      } catch (error) {
        print('error = $error');
      }
    }
    if(alias == null || alias.isEmpty){
      alias = 'all';
    }
    //设置别名
    await jpush.setAlias(alias);

    var userId = Singleton.currentUser.userId;
    var registrationId = await jpush.getRegistrationID();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String? identifierForVendor;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      identifierForVendor = androidInfo.fingerprint;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      identifierForVendor = iosInfo.identifierForVendor;
    }

    UserAPI.registerNotification(
        userId: userId,
        pushToken: null,
        alias: alias,
        registrationId: registrationId,
        identifier: identifierForVendor);
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
