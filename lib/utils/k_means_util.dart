import 'package:uuid/uuid.dart';

class KMeans<M, C> {
  KMeans({
    required this.data,
    required this.num,
    required this.caculateDistance,
    required this.compare,
    required this.caculateCenter,
    required this.convert,
  });

  final List<M> data;
  final int num;
  Map<C, List<M>> _result = {};
  double Function(M, C) caculateDistance;
  int Function(M, M) compare;
  C Function(List<M> list) caculateCenter;
  C Function(M) convert;

  Map<C, List<M>> caculate() {
    if (_result.isNotEmpty) {
      return _result;
    }

    // 2.从数据集中随机选取 k 个数据点作为质心并生成group
    final Map<Uuid, C> clusterDic = makeKList(data);
    Map<Uuid, C> tmpClusters = clusterDic;

    bool finish = false;
    do {
      /// 3.计算[points]与每一个质心的距离。并将该point加入距离最近的Group
      Map<Uuid, List<M>> clusters = grouping(tmpClusters, data);

      /// 4. 更新质心
      tmpClusters = regrouping(clusters);

      /// 5. 按每个[point]和新质心的距离，从新分组。
      var newClusters = grouping(tmpClusters, data);

      /// 如果新组和旧组一致，则完成。否：回到3循环
      finish = compareCluster(before: clusters, after: newClusters);

      if (finish) {
        _result = newClusters
            .map((key, value) => MapEntry(caculateCenter(value), value));
      } else {
        /// 将[newClusters]生成一个没有成员的ClusterList[tmpClusters]，在下一个循环中使用
        tmpClusters.clear();
        tmpClusters = newClusters
            .map((key, value) => MapEntry(key, caculateCenter(value)));
      }
    } while (!finish);

    return _result;
  }

  /// 2.从数据集中随机选取 k 个数据点作为质心；
  Map<Uuid, C> makeKList(List<M> data) {
    Map<Uuid, C> result = {};
    data.sublist(0, num).forEach(
      (m) {
        result[Uuid()] = convert(m);
      },
    );
    return result;
  }

  /// 3.计算[points]与每一个质心的距离。
  /// 并加入最近的那个质心的[cluster]
  Map<Uuid, List<M>> grouping(Map<Uuid, C> clusters, List<M> data) {
    Map<Uuid, List<M>> result = clusters.map((key, value) => MapEntry(key, []));
    data.forEach(
      (m) {
        double distance = double.infinity;
        var _entry = clusters.entries.first;
        clusters.entries.forEach(
          (e) {
            double thisDistance = caculateDistance(m, e.value);
            if (thisDistance < distance) {
              distance = thisDistance;
              _entry = e;
            }
          },
        );

        result[_entry.key]?.add(m);
      },
    );
    return result;
  }

  /// 4. 更新质心
  Map<Uuid, C> regrouping(Map<Uuid, List<M>> map) {
    return map.map((key, value) {
      final center = caculateCenter(value);

      return MapEntry(key, center);
    });
  }

  /// 比较前后结果
  bool compareCluster({
    required Map<Uuid, List<M>> before,
    required Map<Uuid, List<M>> after,
  }) {
    if (before.length != after.length) {
      return false;
    }

    for (Uuid uuid in before.keys) {
      final value1 = before[uuid];
      final value2 = after[uuid];
      if (value1 == null || value2 == null) return false;

      if (!compareList(value1, value2)) return false;
    }

    return true;
  }

  bool compareList(List<M> list1, List<M> list2) {
    if (list1.length != list2.length) return false;
    list1.sort(compare);
    list2.sort(compare);
    for (int i = 0; i < list1.length; i++) {
      if (compare(list1[i], list2[i]) != 0) return false;
    }

    return true;
  }
}
