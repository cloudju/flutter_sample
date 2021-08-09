//
//  FlutterCallableView.swift
//  Runner
//
//  Created by cloudju on 2021/08/07.
//

import Flutter
import Foundation

// 实际在Flutter中被调用的类
class FlutterCallableView : NSObject,FlutterPlatformView, UNUserNotificationCenterDelegate{
    let frame: CGRect;
    let viewId: Int64;
    var messenger: FlutterBinaryMessenger!
    
    var content :String?
    
    init(_ frame: CGRect,
         viewID: Int64,
         args :Any?,
         binaryMessenger: FlutterBinaryMessenger) {
        
        self.frame = frame;
        self.viewId = viewID;
        self.messenger=binaryMessenger;
        if let arg = args as? [String : String],
           let content = arg["content"]{
            self.content = content
            print("!!content: \(String(content))")
        }
        super.init()
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("APP处于前台时接受到通知时被调用.\(requestType(notification))")
        
        completionHandler([.sound, .alert])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        print("打开通知时被调用。\(requestType(response.notification))")
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func requestType(_ notification:UNNotification)->String{
        switch notification.request.trigger{
        case is UNPushNotificationTrigger:
            return "プッシュ通知受信"
        case is UNTimeIntervalNotificationTrigger:
            return "タイマー通知受信"
        case is UNCalendarNotificationTrigger:
            return "カレンダー通知受信"
        case is UNLocationNotificationTrigger:
            return "ロケーション通知受信"
        case .none:
            return "(.none)通知受信"
        case .some(_):
            return "(.some)通知受信"
        }
    }
    
    @available(iOS 10.0, *)
    @objc func timerNotification(){
        let content = UNMutableNotificationContent()
        
        content.title = "Title"
        content.subtitle = "Subtitle" // 新登場！
        content.body = "Body"
        content.sound = UNNotificationSound.default

        // 5秒後に発火
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond",
                                           content: content,
                                           trigger: trigger)

        // ローカル通知予約
        UNUserNotificationCenter.current().add(request){_ in
            print("ローカル通知予約 complet")
        }
    }
    
    func view() -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        
        let label = UILabel()
        label.backgroundColor = .blue
        label.text="这段代码是在ios原生中运行的。"
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        view.addSubview(label)
        
        let label2 = UILabel()
        label2.backgroundColor = .green
        label2.text=self.content ?? "无法取得输入"
        label2.frame = CGRect(x: 0, y: 100, width: 200, height: 100)
        view.addSubview(label2)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 200, width: 200, height: 100))
        btn.backgroundColor = .cyan

        if #available(iOS 10.0, *) {
            btn.setTitle("5秒后通知", for: .normal)
            btn.addTarget(self, action: #selector(timerNotification), for: .touchUpInside)
        } else {
            btn.setTitle("ios 10.0 以后的版本才能运行", for: .normal)
        }
        view.addSubview(btn)
        
        return view;
    }
}

// 工厂类
class FlutterCallableViewFactory : NSObject,FlutterPlatformViewFactory{
    
    var messenger: FlutterBinaryMessenger!
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return FlutterCallableView(frame,viewID : viewId , args : args,binaryMessenger:messenger);
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    @objc public init(messenger: (NSObject & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }
}

// 注册类
class FlutterCallableViewPlugin {
    // flutter的Runner的AppDelegate继承直FlutterPluginRegistry
    // 所以在AppDelegate中注册的时候，只需要[registerWith(registry:self)]即可
    static func registerWith(registry:FlutterPluginRegistry) {
        let pluginKey = "Google_MapView_Plugin";
        guard let registrar = registry.registrar(forPlugin: pluginKey) else{
            return
        }
        let messenger = registrar.messenger() as! (NSObject & FlutterBinaryMessenger)
        
        // [withId]只需和flutter中使用[UiKitView(viewType: )]时，和[viewType]一致即可.
        // 大小写敏感。offcaught。
        registrar.register(
            FlutterCallableViewFactory(
                messenger:messenger
            ),
            withId: "FlutterCallableView"
        );
    }
}
