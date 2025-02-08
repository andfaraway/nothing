import UIKit
import Flutter

import AVFoundation

var channel: FlutterMethodChannel? = nil

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let notificationDic = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        channel = FlutterMethodChannel(name: "com.biubiu.nothing",
                                       binaryMessenger: controller.binaryMessenger)
        channel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "welcomeLoad" {
                result(notificationDic)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    @objc func notificationFlutter(dic: Any?) -> Void {
        channel?.invokeMethod("remoteNotification", arguments: dic)
    }
}

