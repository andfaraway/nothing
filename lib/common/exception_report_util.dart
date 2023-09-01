import 'dart:async';
import 'dart:ui';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nothing/common/constants.dart';

import '../http/api.dart';

class ExceptionReportUtil {
  static void init() {
    if (Constants.isDebugMode) return;

    FlutterError.onError = (FlutterErrorDetails details) {
      StackTrace stackTrace = StackTrace.fromString(details.toString());
      Zone.current.handleUncaughtError(details.exception, stackTrace);
    };

    PlatformDispatcher.instance.onError = (Object obj, StackTrace stack) {
      _reportError(obj, stack);
      return true;
    };
  }

  static Future<void> _reportError(Object obj, StackTrace stack) async {
    DeviceUtils.refreshRuntimeInfo();
    Map<String, dynamic> data = {
      'type': obj.runtimeType.toString(),
      'des': obj.toString(),
      'stack': stack.toString(),
      'deviceInfo': DeviceUtils.deviceInfo,
    };
    await API.exceptionReport(data);
  }
}

class ExceptionTestPage extends StatelessWidget {
  const ExceptionTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              [1, 2, 3][4];
            },
            child: const Text('RangeError'),
          ),
          TextButton(
            onPressed: () {
              String s = {'s': ''}['1']!;
            },
            child: const Text('_TypeError'),
          ),
          TextButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return const Row(
                      children: [
                        Text('fdalfjdaslfidasofjdsaofjdsaofsdaojfjdsaojo'),
                        Text('fdalfjdaslfidasofjdsaofjdsaofsdaojfjdsaojo')
                      ],
                    );
                  });
            },
            child: Text('FlutterError'),
          ),
          TextButton(
            onPressed: () async {
              await platformChannel.invokeMethod(ChannelKey.getBatteryLevel + '1');
            },
            child: const Text('_TypeError'),
          ),
        ],
      ),
    );
  }
}
