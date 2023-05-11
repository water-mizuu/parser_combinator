import "dart:convert";

typedef Vertex = ({int id, String label});
typedef Edge = ({int from, int to});
typedef Graph = ({Set<Vertex> vertices, Set<Edge> edges});

extension GraphMethods on Graph {
  String generateDotFile([Map<int, Map<String, String>> specification = const <int, Map<String, String>>{}]) {
    StringBuffer buffer = StringBuffer();

    List<Edge> edges = this.edges.toList()..sort((Edge a, Edge b) => Comparable.compare(a.from, b.from));
    List<Vertex> vertices = this.vertices.toList()..sort((Vertex a, Vertex b) => Comparable.compare(a.id, b.id));

    buffer.writeln("digraph {");
    for (var (:int id, :String label) in vertices) {
      Iterable<MapEntry<String, String>> entries = specification[id]?.entries ?? <MapEntry<String, String>>[];

      buffer
        ..write("  $id [")
        ..write("label=${jsonEncode(label.replaceAll(r"$", r"$$"))}")
        ..write(<String>[
          for (MapEntry<String, String> entry in entries) ",${jsonEncode(entry.key)}=${jsonEncode(entry.value)}"
        ].join())
        ..write("]")
        ..writeln();
    }
    for (var (:int from, :int to) in edges) {
      buffer.writeln("  $from -> $to");
    }
    buffer.writeln("}");

    return buffer.toString();
  }
}
