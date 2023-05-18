import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:nothing/page/message_page.dart';

import '../common/prefix_header.dart';

class NotificationUtils {
  static final JPush? jPush = Constants.isPhysicalDevice ? JPush() : null;

  //极光推送初始化
  static Future<JPush?> jPushInit() async {
    jPush?.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        LogUtils.d("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        LogUtils.d("flutter onOpenNotification: $message");
        if (globalContext?.widget.toString() != 'MessagePage') {
          BuildContext context = navigatorState.overlay!.context;
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MessagePage()));
        }
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        LogUtils.d("flutter onReceiveMessage: $message");
      },
    );

    jPush?.setup(
      appKey: "713db5486c35b95a967e3b3a",
      channel: "theChannel",
      production: isDebug,
      debug: false, // 设置是否打印 debug 日志
    );

    jPush?.applyPushAuthority(const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    jPush?.setBadge(0);

    return jPush;
  }

  static String? setAlias(String? alias) {
    if (alias == null || jPush == null) return null;
    if (alias.isEmpty) return null;
    String str = HiveBoxes.get(HiveKey.pushAlias, defaultValue: '');
    if (str == '') {
      for (int i = 0; i < alias.length; i++) {
        String c = alias[i];
        if (RegExp('[0-9a-zA-z]').hasMatch(c)) str = str + c;
      }
      try {
        jPush?.setAlias(str);
        HiveBoxes.put(HiveKey.pushAlias, str);
        LogUtils.d('setAlias success');
      } catch (e) {
        LogUtils.d('setAlias error: $e');
      }
    }
    return str;
  }

  static final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  static void initSettings() {
    const AndroidInitializationSettings settingsAndroid = AndroidInitializationSettings('ic_stat_name');
    const IOSInitializationSettings settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: _onReceive,
    );
    const InitializationSettings settings = InitializationSettings(
      android: settingsAndroid,
      iOS: settingsIOS,
    );
    NotificationUtils.plugin.initialize(
      settings,
      onSelectNotification: null,
    );
  }

  static Future<void> register() async {
    if (Constants.isPhysicalDevice) {
      String? registrationId = await NotificationUtils.jPush?.getRegistrationID();
      await API.registerNotification(
          userId: Singleton().currentUser.userId,
          pushToken: null,
          alias: NotificationUtils.setAlias(Singleton().currentUser.username),
          registrationId: registrationId,
          identifier: Singleton().currentUser.openId);
    }
  }

  static Future<void> show(String title, String body) async {
    final Color color = currentThemeColor;
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'nothing_message_channel',
      '推送消息',
      channelDescription: '通知接收到的消息',
      importance: Importance.high,
      priority: Priority.high,
      color: color,
      ticker: 'ticker',
    );
    const IOSNotificationDetails iOSDetails = IOSNotificationDetails();
    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    await NotificationUtils.plugin.show(0, title, body, details);
  }

  static Future<void> cancelAll() {
    return NotificationUtils.plugin.cancelAll();
  }

  static Future<void> _onReceive(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {}
}
