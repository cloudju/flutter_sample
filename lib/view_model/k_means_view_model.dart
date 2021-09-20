import 'package:flutter/painting.dart';
import 'package:flutter_samples/utils/k_means_util.dart';
import 'package:flutter_samples/view_model/view_model.dart';

class KMeansViewModel extends ViewModel {
  String name = 'I am KMeansViewModel';

  List<Offset> points = [];

  void run() {
    print(points);
    final kmeans = KMeans(num: 2, points: points);
    final result = kmeans.caculate();
    //points = result.first;
    print(result);
  }
}
