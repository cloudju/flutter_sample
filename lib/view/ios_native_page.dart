import 'package:flutter/material.dart';

class IosNativePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调用iosNative功能'),
      ),
      body: Container(
        child: UiKitView(viewType: "FlutterCallableView"),
      ),
    );
  }
}
