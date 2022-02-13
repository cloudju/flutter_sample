import 'dart:math';

import 'package:flutter_samples/utils/k_means_albe.dart';
import 'package:flutter_samples/utils/list_ext.dart';

class KMeans<T extends KMeansable> {
  KMeans({
    required this.data,
    required this.k,
  }) {
    if (data.length < k) {
      _result = data;
    }
  }

  final List<T> data;
  final int k;
  List<T> _result = [];
  List<T> get result => _result;
  double sse = 0;

  List<T> caculate() {
    if (_result.isNotEmpty) {
      return _result;
    }

    // 从数据集中随机选取 k 个数据点作为质心并生成group
    List<T> tmpCenter = initClusters();

    bool finish = false;
    do {
      // 计算[points]与每一个质心的距离。并将该point加入距离最近的Group
      List<T> clusters = grouping(tmpCenter);

      // 保存中心点信息用于结果的比较
      final oldCenter = clusters
          .map(
            // class是引用传递，所以需要使用copy方法
            (e) => e.copy() as T,
          )
          .toList();

      /// 更新质心
      updateClusters(clusters);

      /// 按每个[point]和新质心的距离，从新分组。
      _result = grouping(clusters);

      /// 如果新组和旧组一致，则完成。否：再次循环
      finish = compareList(oldCenter, _result);

      if (!finish) {
        tmpCenter = _result
            .map(
              (e) => e.copy() as T,
            )
            .toList();
      }
    } while (!finish);

    // 去掉没有son的Cluster
    _result.removeWhere((e) => e.son.isEmpty);

    /// 计算SSE
    /// 公式参考[doc/sse公式.png]
    for (final c in _result) {
      double sum = 0;
      for (final p in c.son) {
        sum += p.distance(c);
      }
      sse += sum;
    }

    return _result;
  }

  List<T> initClusters() {
    // 初始Cluster为所有数据的中心点圆边上均匀分布的点。
    final center = data.average();

    List<T> res = [];
    assert(center != null);
    if (center == null) return res;

    var distance = 0.0;
    for (final p in data) {
      distance += p.distance(center);
    }
    var r = distance / data.length;
    res.add(center.copy() as T);
    for (int i = 1; i < k; i++) {
      final pt = center.copy() as T;
      pt.dx = center.dx + r * cos(2 * pi * i / k);
      pt.dy = center.dy + r * sin(2 * pi * i / k);
      // pt.dx = center.dx + r * cos(2 * pi * i / k + pi / 4);
      // pt.dy = center.dy + r * sin(2 * pi * i / k + pi / 4);
      res.add(pt);
    }

    return res;

    // 初始Cluster为所有数据的最初K个数据
    // return data
    //     .sublist(0, k)
    //     .map(
    //       (e) => e.copy() as T,
    //     )
    //     .toList();
  }

  /// 3.计算[points]与每一个质心的距离。
  /// 并加入最近的那个质心的[cluster]
  List<T> grouping(List<T> clusters) {
    final result = clusters.map((e) => e.copy() as T).toList();
    for (final item in data) {
      double distance = double.infinity;
      var minCluster = result.first;
      for (var cluster in result) {
        double thisDistance = item.distance(cluster);
        if (thisDistance < distance) {
          distance = thisDistance;
          minCluster = cluster;
        }
      }
      minCluster.son.add(item);
    }
    return result;
  }

  /// 更新质心
  void updateClusters(List<T> clusters) {
    for (var i in clusters) {
      final c = i.son.average();
      if (c != null) {
        i.dx = c.dx;
        i.dy = c.dy;
      }
    }
  }

  bool compareList(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    list1.sort();
    list2.sort();
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].dx != list2[i].dx || list1[i].dy != list2[i].dy) {
        return false;
      }
    }

    return true;
  }
}
