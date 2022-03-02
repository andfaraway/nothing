import UIKit
import Flutter
import flutter_inappwebview

var channel: FlutterMethodChannel? = nil

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let notificationDic = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      channel = FlutterMethodChannel(name: "com.libin.nothing",
                                                    binaryMessenger: controller.binaryMessenger)
      channel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              if call.method == "welcomeLoad" {
                  result(notificationDic)
              }else if call.method == "getBatteryLevel"{
                  self.receiveBatteryLevel(result:result)
              }
          })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current;
      device.isBatteryMonitoringEnabled = true;
      if (device.batteryState == UIDevice.BatteryState.unknown) {
          result(-1);
      } else {
          result(Int(device.batteryLevel * 100));
      }
    }
    
    @objc func notificationFlutter(dic:Any?) -> Void {
        channel?.invokeMethod("remoteNotification", arguments: dic)
    }
    
}

