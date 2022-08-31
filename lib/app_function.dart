//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-29 16:43:59
//
import 'dart:io';

import 'package:nothing/utils/device_utils.dart';
import 'package:nothing/utils/toast_utils.dart';
import 'package:nothing/widgets/webview/in_app_webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'public.dart';

Function? functionWithString(BuildContext context, String functionStr) {
  String? url;
  if ('web:'.matchAsPrefix(functionStr) != null) {
    url = functionStr.split('web:').last;
    functionStr = 'web';
  }
  print('url = $functionStr');
  Function? f;
  switch (functionStr) {
    case 'checkUpdate':
      f = () async {
        String version = await DeviceUtils.version();
        Map<String, dynamic>? data = await API.checkUpdate(Platform.operatingSystem, version);
        if (data != null && data['update'] == true) {
          String url = data['path'];
          if (await canLaunchUrlString(url)) {
            await launchUrlString(url);
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
        Map<String, dynamic>? data = await API.checkUpdate(Platform.operatingSystem, version);
        if (data != null) {
          String url = data['path'];
          if (await canLaunchUrlString(url)) {
            await launchUrlString(url);
          } else {
            throw 'Could not launch $url';
          }
        }
      };
      break;
    case 'web':
      f = () async {
        AppRoutes.pushPage(
            context,
            AppWebView(
              url: url,
              title: 'nothing',
              withAppBar: true,
            ));
        return;
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
