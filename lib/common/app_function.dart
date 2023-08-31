//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-29 16:43:59
//
import 'package:nothing/widgets/app_webview.dart';

import 'prefix_header.dart';

Function? functionWithString(BuildContext context, String functionStr) {
  String? url;
  if ('web:'.matchAsPrefix(functionStr) != null) {
    url = functionStr.split('web:').last;
    functionStr = 'web';
  }
  Log.d('url = $functionStr');
  Function? f;
  switch (functionStr) {
    case 'checkUpdate':
    case 'goUpdate':
      f = () async {
        AppResponse response = await API.checkUpdate();
        if (response.isSuccess) {
          Map<String, dynamic>? data = response.dataMap;
          if (data['update'] == true || functionStr == 'goUpdate') {
            String url = data['path'];
            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            } else {
              throw 'Could not launch $url';
            }
          } else {
            showToast('当前已是最新版本: v${DeviceUtils.deviceInfo.package.version}');
          }
        }
      };
      break;
    case 'web':
      f = () async {
        AppRoute.pushPage(
            context,
            AppWebView(
              url: url,
              title: 'nothing',
            ));
        return;
      };
      break;
  }
  return f;
}
