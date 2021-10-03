import 'package:flutter_samples/utils/map_extends.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("dataSource has 6 data, same as initial data count", () {
    final map = {1: 1, 2: 2, 3: 8, 4: 15, 5: 16};

    //final Map<int, int> tmp = {};

    // if (tmp.isNotEmpty) {
    //   map.clear();
    //   map.addAll(tmp);
    //   tmp.clear();
    // }

    // for (final xx in map.entries) {
    //   final result = map.split((e) {
    //     return (e.value - xx.value).abs() <= 1;
    //   });

    //   if (result[true]!.length == 1) {
    //     continue;
    //   } else {
    //     final mapEntry = result[true]!.summary();
    //     tmp.addAll(result[false]!);
    //     break;
    //   }
    // }

    final result = map.split((b) => b % 2 == 0);

    print(result[true]);
    print(result[false]);
  });

  test("dataSource has 6 data, same as initial data count", () {
    final map = {1: 1, 2: 2, 3: 8, 4: 15, 5: 16};
    final e =
        map.summary((e1, e2) => MapEntry(e1.key + e2.key, e1.value + e2.value));
    print(e);
  });

  test("dataSource has 6 data, same as initial data count", () {
    final map = {1: 1, 0: 2, 3: 8, 4: 15, 5: 16};

    Map<int, int> newMap = {};

    // if (tmp.isNotEmpty) {
    //   map.clear();
    //   map.addAll(tmp);
    //   tmp.clear();
    // }
    do {
      newMap = grouping(map, (a, b) => (a - b).abs() <= 1);
      if (newMap.isNotEmpty) {
        map.clear();
        map.addAll(newMap);
      }
    } while (newMap.isNotEmpty);
    print(map);
  });
}

Map<int, int> grouping(Map<int, int> map, bool Function(int, int) condition) {
  for (final xx in map.entries) {
    final result = map.split((v) {
      return (v - xx.value).abs() <= 1;
    });

    if (result[true]!.length == 1) {
      continue;
    } else {
      final mapEntry = result[true]!.summary(
        (e1, e2) => MapEntry(e1.key + e2.key, e1.value + e2.value),
      );
      result[false]!.addEntries([mapEntry]);
      return result[false]!;
    }
  }
  return {};
}
