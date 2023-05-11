import "dart:collection";

///
/// A [Map] implementation that supports having default values.
///
class DefaultMap<K, V> with MapMixin<K, V> implements Map<K, V> {
  final HashMap<K, V> inner;
  final V Function(DefaultMap<K, V>) backup;

  DefaultMap(this.backup) : inner = HashMap<K, V>();

  @override
  V operator [](covariant K key) => inner[key] ??= backup(this);

  @override
  void operator []=(K key, V value) => inner[key] = value;

  @override
  void clear() => inner.clear();

  @override
  Iterable<K> get keys => inner.keys;

  @override
  Iterable<V> get values => inner.values;

  @override
  V remove(covariant K key) => inner.remove(key) ?? backup(this);
}

///
/// A [DefaultMap] but with weak keys.
///
class DefaultExpando<K extends Object, V extends Object> {
  final String? name;
  final Expando<V> inner;
  final V Function(DefaultExpando<K, V>) backup;

  DefaultExpando(this.backup, [this.name]) : inner = Expando<V>();

  V operator [](covariant K key) => inner[key] ??= backup(this);

  void operator []=(covariant K key, V? value) => inner[key] = value;
}
