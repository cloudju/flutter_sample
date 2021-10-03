import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_samples/view_model/animation_samples_view_model.dart';
import 'package:provider/provider.dart';

/// 参考
/// https://nzigen.com/reference/flutter/2018-04-30-animation/
/// https://itome.team/blog/2019/12/flutter-advent-calendar-day15/

class AnimationSamplesPage extends StatefulWidget {
  @override
  _AnimationSamplesState createState() => _AnimationSamplesState();
}

class _AnimationSamplesState extends State<AnimationSamplesPage>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;
  CurvedAnimation? curvedAnimation;
  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<AnimationSamplesViewModel>(
          builder: (context, viewModel, child) => Column(
            children: [
              Container(
                width: animation?.value * width ?? 100,
                height: 100,
                color: Colors.amber,
              ),
              Transform.translate(
                offset: Offset((animation?.value - 0.5) * width ?? 0, 0),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
              ),
              Transform.rotate(
                angle: animation?.value * 6.28 ?? 0,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                ),
              ),
              Transform.scale(
                scale: curvedAnimation?.value ?? 0,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ),
              Container(
                width: 50 * (curvedAnimation?.value ?? 1).abs(),
                height: 50,
                color: Colors.blue,
              ),
            ],
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
