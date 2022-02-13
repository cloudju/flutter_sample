import 'dart:math';
import 'package:flutter/material.dart';

abstract class Copyable<T> {
  T copy();
}

abstract class KMeansable implements Copyable, Comparable<KMeansable> {
  KMeansable({
    required this.dx,
    required this.dy,
  });
  double dx;
  double dy;

  List<KMeansable> son = [];

  void add<T extends KMeansable>(T obj);

  double distance(KMeansable obj);

  @override
  int compareTo(KMeansable other) {
    if (dx == other.dx && dy == other.dy) {
      return 0;
    } else if (dx > other.dx) {
      return 1;
    } else if (dx == other.dx && dy > other.dy) {
      return 1;
    } else {
      return 0;
    }
  }
}

enum Sharp {
  circle,
  rect,
}

abstract class DrawPointerable {
  DrawPointerable({
    required this.dx,
    required this.dy,
    this.sharp = Sharp.circle,
  });
  double dx;
  double dy;
  Color? color;
  Sharp sharp;
}

class KMeansItem extends KMeansable implements DrawPointerable {
  KMeansItem(
    double x,
    double y, {
    this.sharp = Sharp.circle,
    this.color,
  }) : super(dx: x, dy: y);

  @override
  Color? color;
  @override
  Sharp sharp;

  @override
  void add<T extends KMeansable>(T obj) {
    dx = obj.dx + dx;
    dy = obj.dy + dy;
  }

  // @override
  // operator <<(KMeansable v) {
  //   this.dx = v.dx;
  // }

  @override
  double distance(KMeansable obj) {
    return sqrt((obj.dx - dx) * (obj.dx - dx) + (obj.dy - dy) * (obj.dy - dy));
  }

  @override
  KMeansItem copy() {
    return KMeansItem(dx, dy);
  }

  // @override
  // KMeansItem copy() {
  //   return KMeansItem(dx, dy);
  // }
}
