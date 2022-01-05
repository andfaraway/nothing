import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      application.applicationIconBadgeNumber = 1
      application.applicationIconBadgeNumber = 0
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}

