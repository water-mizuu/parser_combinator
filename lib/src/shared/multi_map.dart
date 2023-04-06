import "dart:collection";
import "dart:math" as math;

typedef Union<A, B> = (A? a, B? b);
typedef Key<K> = Union<K, Symbol>;

class MultiMap<K, V> with MapMixin<List<K>, V> {
  static final Symbol _safeGuard = Symbol(math.Random.secure().nextInt(32).toString());

  final HashMap<Key<K>, Object?> innerMap;
  final int requiredKeyCount;

  MultiMap([this.requiredKeyCount = -1]) : innerMap = HashMap<Key<K>, Object?>();
  const MultiMap.complete(this.innerMap, this.requiredKeyCount);

  V? get(List<K> keys) => _get(keys);
  V set(List<K> keys, V value) => _set(keys, value);

  void _checkKeyLength(List<K> keys) {
    if (requiredKeyCount < 0) {
      return;
    }

    if (keys.length != requiredKeyCount) {
      String message = "The required key count is $requiredKeyCount. "
          "The given keys are ${keys.length} long.";
      throw ArgumentError.value(keys, "", message);
    }
  }

  @override
  String toString() => innerMap.toString();

  /// "Derives" an instance of the [MultiMap].
  /// This is not the same as mathematical derivation. If anything, <br>
  ///   this is closer to derivation of "sentences". <br>
  ///
  /// For example: <br>
  ///   Say there is a MultiMap of: <br>
  ///     A -> B -> C -> D <br>
  ///     A -> B -> D <br>
  ///     A -> C -> E <br>
  ///
  ///   By deriving from "A", we take all the branches that start
  ///     with "A", returning another [MultiMap] cutting off the prefix "A". <br>
  ///
  ///   Effectively, the derived MultiMap is: <br>
  ///     B -> C -> D <br>
  ///     B -> D <br>
  ///     C -> E <br>
  MultiMap<K, V>? derive(K key) => switch (this.innerMap[(key, null)]) {
        HashMap<Key<K>, Object?> value => MultiMap<K, V>.complete(value, requiredKeyCount - 1),
        _ => null,
      };

  @override
  V? operator [](covariant List<K> key) => _get(key);

  @override
  void operator []=(List<K> key, V value) => _set(key, value);

  @override
  void clear() {
    innerMap.clear();
  }

  @override
  Iterable<List<K>> get keys => _keys(innerMap);

  @override
  V? remove(Object? key) => switch (verify(key)) {
        List<K> key when _get(key) != null => _remove(key),
        _ => null,
      };

  @override
  bool containsKey(covariant List<K> key) => _derived(key).containsKey((null, _safeGuard));

  bool get hasIntermediate => innerMap.containsKey((null, _safeGuard));

  HashMap<Key<K>, Object?> _derived(List<K> keys) {
    _checkKeyLength(keys);

    HashMap<Key<K>, Object?> map = innerMap;
    for (int i = 0; i < keys.length; ++i) {
      map = map.putIfAbsent((keys[i], null), HashMap<Key<K>, Object?>.new)! as HashMap<Key<K>, Object?>;
    }

    return map;
  }

  List<K>? verify(Object? key) {
    if (key == null) {
      return null;
    }

    if (key is List) {
      if (key.every((e) => e is K)) {
        return key.cast<K>().toList();
      }
    }
  }

  V? _get(List<K> keys) => _derived(keys)[(null, _safeGuard)] as V?;
  V _set(List<K> keys, V value) => _derived(keys)[(null, _safeGuard)] = value;
  V? _remove(List<K> keys) => _derived(keys).remove([(null, _safeGuard)]) as V?;

  Iterable<List<K>> _keys(HashMap<Key<K>, Object?> map) sync* {
    if (map.containsKey((null, _safeGuard))) {
      yield [];
    }

    for (var (K keys, _) in map.keys.whereType<(K, void)>()) {
      /// Since it's not the safeguard,
      ///  Get the derivative of the map.

      switch (map[(keys, null)]) {
        case HashMap<Key<K>, Object?> derivative:
          yield* _keys(derivative).map((rest) => [keys, ...rest]);
        case null:
          yield [keys];
      }
    }
  }
}

class Trie extends MultiMap<String, bool> {
  Trie();
  const Trie.complete(super.innerMap, super.requiredKeyCount) : super.complete();
  factory Trie.from(Iterable<String> strings) => strings.fold(Trie(), (t, s) => t..add(s));

  bool add(String value) {
    List<String> key = value.split("");

    if (containsKey(key)) {
      return false;
    }
    _set(key, true);

    return true;
  }

  bool contains(String value) {
    List<String> key = value.split("");

    return containsKey(key);
  }

  @override
  Trie? derive(String key) => switch (innerMap[(key, null)]) {
        HashMap<Key<String>, Object?> value => Trie.complete(value, requiredKeyCount - 1),
        _ => null,
      };

  Trie? deriveAll(String value) => value //
      .split("")
      .fold(this, (trie, char) => trie?.derive(char));
}
