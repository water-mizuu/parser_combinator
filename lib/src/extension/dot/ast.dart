import "package:parser_combinator/src/extension/build.dart";
import "package:parser_combinator/src/extension/run.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/default_map.dart";
import "package:parser_combinator/src/shared/graph.dart";

class _Box<V> {
  final V value;
  const _Box(this.value);

  @override
  bool operator ==(Object? other) => identical(this, other);

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => value.toString();
}

Object _combine(Object? v) => v is List ? v.map(_combine).join() : v.toString().trim();
Object _box(Object? v) => v is List ? v.map(_box).toList() : _Box<Object?>(v);
Iterable<Object> _iterate(Object? v) sync* {
  if (v == null) {
    return;
  }

  if (v is List) {
    yield v;
    for (Object? c in v) {
      yield* _iterate(c);
    }
  } else {
    yield v;
  }
}

Graph _generateGraph(Parser<void> parser, String input) {
  Parser<void> built = parser.build();
  Object cst = _box(built.peg(input).cst);

  int i = 0;
  DefaultMap<Object?, int> names = DefaultMap<Object?, int>((_) => ++i);
  Set<int> addedVertices = <int>{};
  Set<Vertex> vertices = <Vertex>{};
  Set<Edge> edges = <Edge>{};
  for (Object obj in _iterate(cst)) {
    int id = names[obj];

    if (addedVertices.add(id)) {
      vertices.add((id: id, label: _combine(obj).toString()));
    }
    if (obj is Iterable<Object?>) {
      for (Object? c in obj) {
        edges.add((from: id, to: names[c]));
      }
    }
  }

  return (vertices: vertices, edges: edges);
}

extension ParserTreeDotExtension<R> on Parser<R> {
  ///
  /// Generates a dot-graph that can be used with
  /// `graphviz` to generate an illustration that describes
  /// the parse tree.
  ///
  String generateDotGraphForCst(String input) => _generateGraph(this, input).generateDotFile();
}
