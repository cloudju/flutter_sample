import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IosNativePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调用iosNative功能'),
      ),
      body: Container(
        child: Platform.isIOS
            ? Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                child: UiKitView(
                  viewType: "FlutterCallableView",
                  creationParams: {
                    "content": "flutter 传入的文本内容",
                  },
                  //参数的编码方式
                  creationParamsCodec: const StandardMessageCodec(),
                ),
              )
            : Text('这段代码只能在ios上运行。残念'),
      ),
    );
  }
}
