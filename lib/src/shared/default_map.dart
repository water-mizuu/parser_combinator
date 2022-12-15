import "dart:collection";

///
/// A [Map] implementation that supports having default values.
///
class DefaultMap<K, V> with MapMixin<K, V> implements Map<K, V> {
  final HashMap<K, V> inner;
  final V Function(DefaultMap<K, V>, K) backup;

  DefaultMap(this.backup) : inner = HashMap();

  @override
  V operator [](covariant K key) => inner[key] ??= backup(this, key);

  @override
  void operator []=(K key, V value) => inner[key] = value;

  @override
  void clear() => inner.clear();

  @override
  Iterable<K> get keys => inner.keys;

  @override
  Iterable<V> get values => inner.values;

  @override
  V remove(covariant K key) => inner.remove(key) ?? backup(this, key);
}

///
/// A [DefaultMap] but with weak keys.
///
class DefaultExpando<K extends Object, V extends Object> implements Expando<V> {
  @override
  final String? name;
  final Expando<V> inner;
  final V Function(DefaultExpando<K, V>, K) backup;

  DefaultExpando(this.backup, [this.name]) : inner = Expando();

  @override
  V operator [](covariant K key) => inner[key] ??= backup(this, key);

  @override
  void operator []=(covariant K key, V? value) => inner[key] = value;
}
