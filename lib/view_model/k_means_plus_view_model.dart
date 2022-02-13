import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/k_means_albe.dart';
import 'package:flutter_samples/view_model/view_model.dart';

import '../utils/k_means_util2.dart';

enum KmeansPlusStatus {
  input,
  result,
}

class KMeansPlusViewModel extends ViewModel {
  String name = 'I am KMeansViewModel';

  List<Offset> points = [];

  KMeans<KMeansItem>? kmeans;

  KmeansPlusStatus status = KmeansPlusStatus.input;

  void caculate() {
    final forK = points.map((e) => KMeansItem(e.dx, e.dy)).toList();

    final sw = Stopwatch();
    sw.start();

    List<KMeans<KMeansItem>> resList = [];
    for (int k = 2; k < 10; k++) {
      final kmeans = KMeans<KMeansItem>(data: forK, k: k);
      kmeans.caculate();
      resList.add(kmeans);
    }

    List<double> sseList = resList.map((e) => e.sse).toList();

    // sse的1阶导数
    List<double> ssed1 = [0];
    for (int i = 1; i < sseList.length; i++) {
      ssed1.add((sseList[i - 1] - sseList[i]) / 2);
    }
    // sse的2阶导数
    List<double> ssed2 = [0];
    for (int i = 1; i < ssed1.length; i++) {
      ssed2.add((ssed1[i - 1] - ssed1[i]) / 2);
    }

    var max = 0.0;
    var index = 0;
    for (var i = 1; i < ssed2.length; i++) {
      if (ssed2[i] > max) {
        max = ssed2[i];
        index = i;
      }
    }

    kmeans = resList[index];
    sw.stop();
    if (kDebugMode) {
      print(
          'i:$index,     ssed2:${ssed2.length},\tssed1:${ssed1.length},\tsseList:${sseList.length}');
      for (int i = 0; i < sseList.length; i++) {
        print(
            'i:$i,     ssed2:${ssed2[i]},\tssed1:${ssed1[i]},\tsseList:${sseList[i]}');
      }
      print('used time:${sw.elapsed}');
    }

    status = KmeansPlusStatus.result;
    notifyListeners();
  }

  List<DrawPointerable> kmResult(List<KMeansItem> list) {
    List<DrawPointerable> pt = [];
    for (var i = 0; i < list.length; i++) {
      final color = colors[i % colors.length];
      list[i].color = color.withAlpha(0x60);
      list[i].sharp = Sharp.rect;
      pt.add(list[i]);
      for (final son in list[i].son) {
        pt.add(KMeansItem(son.dx, son.dy, sharp: Sharp.circle, color: color));
      }
    }

    return pt;

    // return DrawPointWidget(
    //   points: pt,
    //   size: size,
    //   origin: origin,
    // );
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

  static const colors = [
    Colors.black,
    Colors.red,
    Color.fromARGB(224, 203, 154, 5),
    Color.fromARGB(255, 110, 255, 7),
    Color.fromARGB(255, 7, 230, 255),
    Color.fromARGB(255, 7, 98, 255),
    Color.fromARGB(255, 160, 7, 255),
    Color.fromARGB(255, 251, 7, 255),
    Color.fromARGB(255, 225, 113, 149),
    Color.fromARGB(255, 214, 255, 7),
    Color.fromARGB(255, 255, 255, 7),
    Color.fromARGB(255, 4, 112, 42),
    Color.fromARGB(255, 47, 135, 172),
  ];
}
