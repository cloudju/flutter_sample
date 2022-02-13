import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/k_means_util.dart';
import 'package:flutter_samples/view_model/view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';

enum KmeansPlusStatus {
  input,
  result,
}

class KMeansPlusViewModel extends ViewModel {
  String name = 'I am KMeansViewModel';

  List<Offset> points = [];

  KmeansPlusStatus status = KmeansPlusStatus.input;

  void caculate() {
    status = KmeansPlusStatus.result;
    notifyListeners();
  }

  Map<Offset, List<Offset>>? result;

  List<Color> colorList = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.pink,
    Colors.grey,
    Colors.yellow,
    Colors.blueGrey,
    Colors.blueAccent,
    Colors.yellowAccent,
  ];

  void run() {
    final kmeans = KMeans<Offset, Offset>(
      data: points,
      num: colorList.length,
      caculateDistance: caculateDistance,
      compare: compare,
      caculateCenter: caculateCenter,
      convert: convert,
    );
    final tmp = kmeans.caculate();
    result = tmp;

    notifyListeners();
  }

  Widget resultWigdet(Map<Offset, List<Offset>> data, Size size) {
    final list = data.entries.map((e) => e.value).toList();

    List<DrawPointWidget> widgets = [
      DrawPointWidget(
        size: size,
        radius: 8,
        points: data.entries.map((e) => e.key).toList(),
        color: Colors.red,
      ),
    ];

    for (int i = 0; i < list.length; i++) {
      widgets.add(
        DrawPointWidget(
          size: size,
          points: list[i],
          color: colorList[i],
        ),
      );
    }
    return Stack(
      children: widgets,
    );
  }

  void clear() {
    points.clear();
    if (result != null) result!.clear();
    result = null;
    notifyListeners();
  }

  double caculateDistance(Offset m, Offset c) {
    final ss = (x) => x * x;
    return sqrt(ss(m.dx - c.dx) + ss(m.dy - c.dy));
  }

  final compare = (Offset p1, Offset p2) => p1.dx.compareTo(p2.dx) == 0
      ? p1.dy.compareTo(p2.dy)
      : p1.dx.compareTo(p2.dx);

  Offset caculateCenter(List<Offset> list) {
    var dx = 0.0;
    var dy = 0.0;
    list.forEach((e) {
      dx += e.dx;
      dy += e.dy;
    });

    return Offset(dx / list.length, dy / list.length);
  }

  Offset convert(Offset p) => p;
}
