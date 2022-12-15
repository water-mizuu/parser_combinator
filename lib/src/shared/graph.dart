
import "dart:convert";

typedef Vertex = ({int id, String label});
typedef Edge = ({int from, int to});
typedef Graph = ({Set<Vertex> vertices, Set<Edge> edges});

extension GraphMethods on Graph {
  String generateDotFile([Map<int, Map<String, String>> specification = const {}]) {
    StringBuffer buffer = StringBuffer();

    List<Edge> edges = this.edges.toList()
        ..sort((a, b) => Comparable.compare(a.from, b.from));
    List<Vertex> vertices = this.vertices.toList()
        ..sort((a, b) => Comparable.compare(a.id, b.id));

    buffer.writeln("digraph {");
    for (Vertex node in vertices) {
      Iterable<MapEntry<String, String>> entries = specification[node.id]?.entries ?? [];

      buffer
          ..write("  ${node.id} [")
          ..write("label=${jsonEncode(node.label.replaceAll(r"$", r"$$"))}")
          ..write([
            for (MapEntry<String, String> entry in entries)
                    ",${jsonEncode(entry.key)}=${jsonEncode(entry.value)}"].join())
          ..write("]")
          ..writeln();
    }
    for (Edge edge in edges) {
      buffer.writeln("  ${edge.from} -> ${edge.to}");
    }
    buffer.writeln("}");

    return buffer.toString();
  }
}
