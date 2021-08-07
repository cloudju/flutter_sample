import 'dart:io';

import 'package:flutter/material.dart';

class IosNativePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调用iosNative功能'),
      ),
      body: Container(
        child: Platform.isIOS
            ? UiKitView(viewType: "FlutterCallableView")
            : Text('这段代码只能在ios上运行。残念'),
      ),
    );
  }
}
