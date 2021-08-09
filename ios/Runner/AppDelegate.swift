import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    //注册flutter控件
    FlutterCallableViewPlugin.registerWith(registry:  self)
    
    //取得通知中心权限
    if #available(iOS 10.0, *) {
        getPermisson()
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    @available(iOS 10.0, *)
    func getPermisson(){
        let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if error != nil {
                // エラー
                return
            }

            if granted {
                // 通知許可された
                print("通知許可された")
            } else {
                // 通知拒否
                print("通知拒否")
            }
        }
    }

}
