import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     var dic = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]
      print(dic)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}

