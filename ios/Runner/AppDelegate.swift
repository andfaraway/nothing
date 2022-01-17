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
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      channel = FlutterMethodChannel(name: "com.libin.nothing",
                                                    binaryMessenger: controller.binaryMessenger)
      channel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              
          })
    GeneratedPluginRegistrant.register(with: self)
      
    var dic = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
    if(dic != nil){
          print(dic)
         self.perform(#selector(notificationFlutter), with: dic, afterDelay: 2)
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    @objc func notificationFlutter(dic:Dictionary<String, Any>) -> Void {
        channel?.invokeMethod("remoteNotification", arguments: dic)
    }
    
}

