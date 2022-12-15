import "dart:collection";
import "dart:math" as math;

class MultiMap<K, V> with MapMixin<List<K>, V> {
  static final Symbol _safeGuard = Symbol(math.Random.secure().nextInt(32).toString());

  HashMap<Object?, Object?> innerMap = HashMap<Object?, Object?>();
  final int requiredKeyCount;

  MultiMap([this.requiredKeyCount = -1]);
  MultiMap.complete(this.innerMap, this.requiredKeyCount);

  V? get(List<K> keys) => _get(keys);
  V set(List<K> keys, V value) => _set(keys, value);

  void _checkKeyLength(List<K> keys) {
    if (requiredKeyCount < 0) {
      return;
    }

    if (keys.length != requiredKeyCount) {
      String message = "The required key count is $requiredKeyCount. The given keys are ${keys.length} long.";
      throw ArgumentError.value(keys, "", message);
    }
  }

  @override
  String toString() => innerMap.toString();

  MultiMap<K, V>? derive(K key) {
    Object? value = this.innerMap[key];
    if (value is HashMap) {
      return MultiMap.complete(value, requiredKeyCount - 1);
    }

    return null;
  }

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
  V? remove(covariant List<K> key) {
    V? value = _get(key);

    if (value == null) {
      return null;
    }
    _derived(key).remove(_safeGuard);
  }

  @override
  bool containsKey(covariant List<K> key) => _derived(key).containsKey(_safeGuard);

  bool get hasIntermediate => innerMap.containsKey(_safeGuard);

  HashMap<Object?, Object?> _derived(List<K> keys) {
    _checkKeyLength(keys);

    HashMap<Object?, Object?> map = innerMap;
    for (int i = 0; i < keys.length; ++i) {
      map = map.putIfAbsent(keys[i], HashMap<Object?, Object?>.new)! as HashMap<Object?, Object?>;
    }

    return map;
  }

  V? _get(List<K> keys) => _derived(keys)[_safeGuard] as V?;
  V _set(List<K> keys, V value) => _derived(keys)[_safeGuard] = value;

  Iterable<List<K>> _keys(HashMap<Object?, Object?> map) sync* {
    if (map.containsKey(_safeGuard)) {
      yield [];
    }

    for (K key in map.keys.whereType<K>()) {
      // Since it's not the safeguard,
      //  Get the derivative of the map.

      Object? derivative = map[key];
      if (derivative == null) {
        yield [key];
      } else if (derivative is HashMap<Object?, Object?>) {
        for (List<K> rest in _keys(derivative)) {
          yield [key, ...rest];
        }
      } else {
        throw Exception("What is this? $derivative");
      }
    }
  }
}

class Trie extends MultiMap<String, bool> {
  Trie();
  Trie.complete(super.innerMap, super.requiredKeyCount) : super.complete();
  factory Trie.from(Iterable<String> strings) => strings.fold(Trie(), (t, s) => t..add(s));

  bool add(String value) {
    List<String> key = value.split("");

    if (containsKey(key)) {
      return false;
    }
    return _set(key, true);
  }

  bool contains(String value) {
    List<String> key = value.split("");

    return containsKey(key);
  }

  @override
  Trie? derive(String key) {
    Object? value = innerMap[key];
    if (value is HashMap) {
      return Trie.complete(value, requiredKeyCount - 1);
    }

    return null;
  }

  Trie? deriveAll(String value) => value //
      .split("")
      .fold(this, (trie, char) => trie?.derive(char));
}
