//
//  [Author] libin
//  [Date] 2022-01-20 10:24:40
//

import 'package:flutter/services.dart';

const MethodChannel platformChannel = MethodChannel('com.biubiu.nothing');

class ChannelKey {
  static const String backToDeskTop = 'backToDeskTop';
  static const String welcomeLoad = 'welcomeLoad';
  static const String getBatteryLevel = 'getBatteryLevel';
  static const String createLivePhoto = 'createLivePhoto';
}
