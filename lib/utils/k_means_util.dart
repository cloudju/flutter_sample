import 'package:flutter/painting.dart';
import 'dart:math';

import 'package:uuid/uuid.dart';

class KMeans {
  KMeans({
    required List<Offset> points,
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
  late final List<Member> members;
  final int num;

  Map<Offset, List<Offset>> _result = {};

  Map<Offset, List<Offset>> caculate() {
    if (_result.isNotEmpty) {
      return _result;
    }

    // 2.从数据集中随机选取 k 个数据点作为质心并生成group
    Map<Uuid, Cluster> tmpClusters = _makeKList();

    bool finish = false;
    do {
      /// 3.计算[points]与每一个质心的距离。并将该point加入距离最近的Group
      Map<Uuid, Cluster> clusters = grouping(tmpClusters);

      /// 4. 更新质心
      Map<Uuid, Cluster> newClusters = regrouping(clusters);

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
  void makeResult(Map<Uuid, Cluster> clusters) {
    // _result = clusters.entries
    //     .map(
    //       (c) => c.value.members
    //           .map(
    //             (m) => Offset(m.pt.dx, m.pt.dy),
    //           )
    //           .toList(),
    //     )
    //     .toList();
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
  Map<Uuid, Cluster> _makeKList() {
    Map<Uuid, Cluster> result = {};
    members.sublist(0, num).forEach(
      (m) {
        result[Uuid()] = Cluster(m.pt);
      },
    );
    return result;
  }

  /// 3.计算[points]与每一个质心的距离。
  /// 并加入最近的那个质心的[cluster]
  Map<Uuid, Cluster> grouping(Map<Uuid, Cluster> clusters) {
    members.forEach(
      (m) {
        double distance = double.infinity;
        Uuid clusterId = clusters.entries.first.key;
        clusters.forEach(
          (uuid, c) {
            double thisDistance = _distance(m.pt, c.center);
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

  ///
  double _distance(Offset pt1, Offset pt2) {
    final xx = (double x) => x * x;
    return sqrt(xx(pt1.dx - pt2.dx) + xx(pt1.dy - pt2.dy));
  }

  /// 4. 选出新的质心
  Map<Uuid, Cluster> regrouping(Map<Uuid, Cluster> clusters) {
    Map<Uuid, Cluster> newClusters = {};
    clusters.forEach(
      (key, c) {
        double dx = 0.0;
        double dy = 0.0;

        c.members.forEach((m) {
          dx += m.pt.dx;
          dy += m.pt.dy;
        });
        newClusters[key] = Cluster(
          Offset(
            dx / c.members.length,
            dy / c.members.length,
          ),
        );
      },
    );
    return newClusters;
  }
}

class Member {
  Member({
    required this.id,
    required this.pt,
    required this.distance,
  });

  int id;
  Offset pt;
  double distance;
}

class Cluster {
  Cluster(this.center);

  /// 质心
  Offset center;
  List<Member> members = [];
  void add(Member menber) {
    members.add(menber);
  }

  /// 用所有成员xy的平均值，计算出新的中心点
  Offset caculateAveragePoint() {
    return Offset(0, 0);
  }

  int maxMember() {
    int xx = 0;
    members.forEach((m) {
      if (m.id > xx) {
        xx = m.id;
      }
    });
    return xx;
  }

  bool compare(Cluster cluster) {
    if (members.length != cluster.members.length) {
      return false;
    }

    return true;
  }
}
