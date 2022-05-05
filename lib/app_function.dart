//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-29 16:43:59
//
import 'package:nothing/utils/device_utils.dart';
import 'package:nothing/utils/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/user_api.dart';

Function? functionWithString(String functionStr) {
  List l = functionStr.split('~');
  String functionName = l.first;
  String? url;
  if(l.length == 2){
    url = l[1];
  }

  Function? f;
  switch (functionName) {
    case 'checkUpdate':
      f = () async {
        String version = await DeviceUtils.version();
        Map<String, dynamic>? data = await UserAPI.checkUpdate('ios', version);
        if (data != null && data['update'] == true) {
          String url = data['path'];
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        } else {
          showToast('当前已是最新版本: v$version');
        }
      };
      break;
    case 'goUpdate':
      f = () async {
        String version = await DeviceUtils.version();
        Map<String, dynamic>? data = await UserAPI.checkUpdate('ios', version);
        if (data != null) {
          String url = data['path'];
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        }
      };
      break;
    case 'openUrl':
      f = () async {
          if (await canLaunch(url!)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
      };
      break;
  }
  return f;
}
