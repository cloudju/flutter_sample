import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_samples/utils/custom_offset.dart';
import 'package:flutter_samples/utils/k_means_util.dart';
import 'package:flutter_samples/view_model/view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';

class KMeansViewModel extends ViewModel {
  String name = 'I am KMeansViewModel';

  List<Offset> points = [];

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
    final ptList = points.map((e) => CustomOffset(pt: e)).toList();
    final kmeans = KMeans(num: colorList.length, points: ptList);
    result = kmeans.caculate().map(
          (key, value) => MapEntry(
            Offset(key.pt.dx, key.pt.dy),
            value
                .map(
                  (e) => Offset(e.pt.dx, e.pt.dy),
                )
                .toList(),
          ),
        );
    //result = clusters.keys.map((e) => e).toList();

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
}
