import 'package:uuid/uuid.dart';

abstract class KMeansItem<T> {
  double distance(T item);
  bool compare(List<T> list1, List<T> list2);
  T average(List<T> list);
}

class KMeans<T extends KMeansItem> {
  KMeans({
    required List<T> points,
    required this.num,
  }) {
    members = [];
    for (int i = 0; i < points.length; i++) {
      members.add(
        Member(
          id: i,
          pt: points[i],
          distance: 0,
        ),
      );
    }
  }
  late final List<Member<T>> members;
  final int num;

  Map<T, List<T>> _result = {};

  Map<T, List<T>> caculate() {
    if (_result.isNotEmpty) {
      return _result;
    }

    // 2.从数据集中随机选取 k 个数据点作为质心并生成group
    Map<Uuid, Cluster<T>> tmpClusters = _makeKList();

    bool finish = false;
    do {
      /// 3.计算[points]与每一个质心的距离。并将该point加入距离最近的Group
      Map<Uuid, Cluster<T>> clusters = grouping(tmpClusters);

      /// 4. 更新质心
      Map<Uuid, Cluster<T>> newClusters = regrouping(clusters);

      /// 5. 按每个[point]和新质心的距离，从新分组。
      newClusters = grouping(newClusters);

      /// 如果新组和旧组一致，则完成。否：回到3循环
      finish = compare(newClusters, clusters);

      if (finish) {
        makeResult(newClusters);
      } else {
        /// 将[newClusters]生成一个没有成员的ClusterList[tmpClusters]，在下一个循环中使用
        /// TODO: 是否可以直接克隆？？？
        tmpClusters.clear();
        newClusters.entries.forEach((c) {
          tmpClusters[c.key] = Cluster(c.value.center);
        });
      }
    } while (!finish);

    return _result;
  }

  /// 从[clusters]提取结果
  void makeResult(Map<Uuid, Cluster<T>> clusters) {
    clusters.entries.forEach((e) {
      _result[e.value.center] = e.value.members.map((m) => m.pt).toList();
    });
  }

  /// 比较两个Cluster列表的成员是否一致。
  bool compare(Map<Uuid, Cluster> cs1, Map<Uuid, Cluster> cs2) {
    //比较长度
    if (cs1.length != cs2.length) {
      return false;
    }

    for (Uuid uuid in cs1.keys) {
      final c1 = cs1[uuid];
      final c2 = cs2[uuid];

      if (c1 != null && c2 != null) {
        if (!c1.compare(c2)) return false;
      } else {
        return false;
      }
    }

    return true;
  }

  /// 2.从数据集中随机选取 k 个数据点作为质心；
  Map<Uuid, Cluster<T>> _makeKList() {
    Map<Uuid, Cluster<T>> result = {};
    members.sublist(0, num).forEach(
      (m) {
        result[Uuid()] = Cluster(m.pt);
      },
    );
    return result;
  }

  /// 3.计算[points]与每一个质心的距离。
  /// 并加入最近的那个质心的[cluster]
  Map<Uuid, Cluster<T>> grouping(Map<Uuid, Cluster<T>> clusters) {
    members.forEach(
      (m) {
        double distance = double.infinity;
        Uuid clusterId = clusters.entries.first.key;
        clusters.forEach(
          (uuid, c) {
            double thisDistance = m.pt.distance(c.center);
            if (thisDistance < distance) {
              distance = thisDistance;
              clusterId = uuid;
            }
          },
        );
        m.distance = distance;
        clusters[clusterId]?.add(m);
      },
    );
    return clusters;
  }

  /// 4. 选出新的质心
  Map<Uuid, Cluster<T>> regrouping(Map<Uuid, Cluster<T>> clusters) {
    Map<Uuid, Cluster<T>> newClusters = {};
    clusters.forEach(
      (key, c) {
        newClusters[key] =
            Cluster(c.center.average(c.members.map((e) => e.pt).toList()));
      },
    );
    return newClusters;
  }
}

class Member<T extends KMeansItem> {
  Member({
    required this.id,
    required this.pt,
    required this.distance,
  });

  int id;
  T pt;
  double distance;
}

class Cluster<T extends KMeansItem> {
  Cluster(this.center);

  /// 质心
  T center;
  List<Member<T>> members = [];
  void add(Member<T> menber) {
    members.add(menber);
  }

  bool compare(Cluster<T> cluster) {
    if (members.length != cluster.members.length) {
      return false;
    }

    return true;
  }
}
