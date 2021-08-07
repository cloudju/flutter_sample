//
//  FlutterCallableView.swift
//  Runner
//
//  Created by cloudju on 2021/08/07.
//

import Flutter
import Foundation

// 实际在Flutter中被调用的类
class FlutterCallableView : NSObject,FlutterPlatformView{
    let frame: CGRect;
    let viewId: Int64;
    var messenger: FlutterBinaryMessenger!
    
    init(_ frame: CGRect,viewID: Int64,args :Any?, binaryMessenger: FlutterBinaryMessenger) {
        self.frame = frame;
        self.viewId = viewID;
        self.messenger=binaryMessenger;
        print("!!!!!!!!!!!!!!!from flutter call a view build by swift!!!!!!!!!!!!!!!!!!\(frame)");
    }
    
    func view() -> UIView {
        let mapView = UILabel()
        mapView.text="这段代码是在ios原生中运行的。"
        mapView.frame = frame
        return mapView;
    }
}

// 工厂类
class FlutterCallableViewFactory : NSObject,FlutterPlatformViewFactory{
    
    var messenger: FlutterBinaryMessenger!
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return FlutterCallableView(frame,viewID : viewId , args : args,binaryMessenger:messenger);
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
