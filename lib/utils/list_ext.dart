import 'package:flutter_samples/utils/k_means_albe.dart';

extension ListEx<T extends KMeansable> on List {
  T? average() {
    if (isEmpty) {
      return null;
    }

    T? result;
    for (T i in this) {
      if (result == null) {
        result = i.copy();
      } else {
        result.add(i);
      }
    }

    assert(result != null);
    result!.dx = result.dx / length;
    result.dy = result.dy / length;
    return result;
  }
}
