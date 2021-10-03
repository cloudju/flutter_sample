import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_samples/view_model/3d_animation_view_model.dart';
import 'package:provider/provider.dart';

/// 参考
/// https://blog.csdn.net/linjf520/article/details/106819425
/// https://juejin.cn/post/6844903709470621710

class Animation3dPage extends StatefulWidget {
  @override
  _AnimationSamplesState createState() => _AnimationSamplesState();
}

class _AnimationSamplesState extends State<Animation3dPage>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;
  CurvedAnimation? curvedAnimation;
  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(animationController!);
    curvedAnimation =
        CurvedAnimation(parent: animationController!, curve: ShakeCurve());

    animationController?.addListener(() {
      setState(() {});
    });
    animationController?.repeat();

    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController?.dispose();
      animationController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //print('${Matrix4.identity()..setEntry(2, 3, 0.001)}');
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<Animation3dViewModel>(
          builder: (context, viewModel, child) => Transform(
            //transform: Matrix4.skew(math.pi / 8, 0),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.005)
              ..rotateX(math.pi * (curvedAnimation?.value ?? 0)),
            alignment: FractionalOffset.center,
            //alignment: FractionalOffset(0.5, 1),
            child: SizedBox(
              width: 200,
              child: Image.asset('assets/1.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(2 * math.pi * t);
  }
}
