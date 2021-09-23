import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/k_means_util.dart';

class CustomOffset extends KMeansItem<CustomOffset> {
  CustomOffset({
    required this.pt,
  });
  final Offset pt;

  @override
  CustomOffset average(List<CustomOffset> list) {
    double dx = 0;
    double dy = 0;
    list.forEach((e) {
      dx += e.pt.dx;
      dy += e.pt.dy;
    });

    return CustomOffset(
      pt: Offset(
        dx / list.length,
        dy / list.length,
      ),
    );
  }

  @override
  bool compare(List<CustomOffset> list1, List<CustomOffset> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].pt.dx == list2[i].pt.dx ||
          list1[i].pt.dy == list2[i].pt.dy) {
        return false;
      }
    }
    return true;
  }

  @override
  double distance(CustomOffset item) {
    final pt1 = this.pt;
    final pt2 = item.pt;
    final xx = (double x) => x * x;
    return sqrt(xx(pt1.dx - pt2.dx) + xx(pt1.dy - pt2.dy));
  }
}
