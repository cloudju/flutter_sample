1. 修改[Info.plist]  
  在`ios/Runner/Info.plist`中添加如下代码
    ```plist
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    ```

2. 添加希望在flutter中被调用的Swift代码。参考[FlutterCallableView](ios/Runner/FlutterCallableView.swift)

3. 添加工厂类。参考[FlutterCallableView](ios/Runner/FlutterCallableView.swift)

4. 添加注册类。参考[FlutterCallableView](ios/Runner/FlutterCallableView.swift)

5. 在`ios/Runner/AppDelegate.swift`中调用注册类。参考[application(:)](ios/Runner/AppDelegate.swift)

6. 在flutter中使用`UiKitView`调用Step1中生成的代码。参考[IosNativePage](lib/view/ios_native_page.dart)