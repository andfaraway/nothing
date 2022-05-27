import UIKit
import Flutter
import flutter_inappwebview

import AVFoundation

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
              }else if call.method == "image_to_mov" || call.method == "create_live_photo"{
                  self.createLivePhoto(method: call.method,arguments: call.arguments, result: result)
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
    
    func createLivePhoto(method:String,arguments:Any?,result:@escaping FlutterResult) ->  Void{
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        print("method = \(method)")
        if method == "image_to_mov" {
               let path = arguments as! String
               let imageURL = URL.init(fileURLWithPath: path)
               let videoSettings = CXEImageToVideoSync.videoSettings(codec: AVVideoCodecType.h264
               .rawValue, width: Int(width), height: Int(height))
               let sync = CXEImageToVideoSync(videoSettings: videoSettings)
               let fileURL = sync.createMovieFrom(url: imageURL, duration: 4)
               result(fileURL.absoluteString)
        }else if method == "create_live_photo" {
                 let pathList = arguments as! Array<String>
       //           let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
       //
       //           let photoURL = URL.init(fileURLWithPath: pathList.first!)
       //           let sourceVideoPath = URL.init(fileURLWithPath: pathList.last!)

                 let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                 let photoURL = URL.init(fileURLWithPath: path+"/photo.jpg")
                 let sourceVideoPath = URL.init(fileURLWithPath: path+"/second.mov")

                 
                LivePhoto.generate(from: photoURL, videoURL: sourceVideoPath, progress: { (percent) in

                }) { (livePhoto, resources) in
                   result(resources?.pairedImage ?? "empty image")
                   result(resources?.pairedVideo ?? "empty video")
                    
                    if let resources = resources {
                        LivePhoto.saveToLibrary(resources, completion: { (success) in
                            if success {
                                  result("success")
       //                          self.postAlert("Live Photo Saved", message:"The live photo was successfully saved to Photos.")
                            }
                            else {
                                   result("default")
       //                          self.postAlert("Live Photo Not Saved", message:"The live photo was not saved to Photos.")
                            }
                        })
                    }
                }
             }
    }
    
    
}

