extension MapExt<K, V> on Map<K, V> {
  Map<bool, Map<K, V>> split(
    bool Function(V) condition,
  ) {
    Map<K, V> mapTrue = {};
    Map mapFalse = {};
    this.forEach((k, v) {
      if (condition(v)) {
        mapTrue.addEntries([MapEntry(k, v)]);
      } else {
        mapFalse[k] = v;
      }
    });
    return {true: mapTrue.cast(), false: mapFalse.cast()};
  }

  MapEntry<K, V> summary(
      MapEntry<K, V> Function(MapEntry<K, V>, MapEntry<K, V>) add) {
    MapEntry<K, V>? me;
    this.entries.forEach((e) {
      me = me == null ? e : add(me!, e);
    });

    return me!;
  }
}
