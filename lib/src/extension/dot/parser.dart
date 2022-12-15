
import "package:parser_combinator/parser_combinator.dart";
import "package:parser_combinator/src/shared/graph.dart";

extension ParserGraphDotExtension<R> on Parser<R> {
  Graph _generateTrueGraph() {
    Parser<void> built = build();

    int i = 0;
    Map<Parser<void>, int> ids = {};
    int grabId(Parser<void> parser) => ids[parser] ??= ++i;

    Set<Edge> edges = {};
    Set<Vertex> vertices = {};

    for (Parser<void> parser in built.traverse()) {
      int parserId = grabId(parser);

      vertices.add((id: parserId, label: "$parser"));
      for (Parser<void> child in parser.children) {
        int childId = grabId(child);

        edges.add((from: parserId, to: childId));
      }
    }

    return (edges: edges, vertices: vertices);
  }

  (Graph, Set<int>) _generateRuleGraph({Map<int, String> ruleNames = const {}}) {
    Parser<void> built = build();
    List<Parser<void>> rules = built.rules().toList();

    int i = 0;
    Map<Parser<void>, int> ids = {};

    int grabId(Parser<void> parser) => ids[parser] ??= ++i;
    String ruleName(int id) => ruleNames[id] ?? "Rule $id";

    Set<int> ruleNodeIds = {};
    Set<Edge> edges = {};
    Set<Vertex> vertices = {
      /// Register the ids of each rule.
      for (Parser<void> rule in rules)
        (id: grabId(rule), label: rule.toString()),
    };

    for (Parser<void> rule in rules) {
      /// This cannot be null, though just to be safe.
      int id = grabId(rule);

      /// This WILL be null.
      int dummyId = grabId(blank());
      ruleNodeIds.add(dummyId);

      /// Add a dummy "root" node with the label "Rule #"
      /// which connects to the memoized parser node.
      edges.add((from: dummyId, to: id));
      vertices.add((id: dummyId, label: ruleName(id)));
    }

    for (Parser<void> rule in rules) {
      for (Parser<void> descendant in rule.traverseShallow().where(Parser.isNotTerminal)) {
        /// If the descendant is not terminal
        ///   Add a node for descendant.
        ///   For each child in the children of descendant
        ///     If the child is memoized, then it is either terminal or a reference to a rule.
        ///       Therefore, assign a dummy id, and
        ///         If it is a terminal
        ///           Add a dummy node with label of the terminal.
        ///         Else
        ///           Add a dummy node with the rule number.
        ///     Else, it is a regular node.
        ///       Therefore, just attach an edge from the descendant to the child.

        int descendantId = grabId(descendant);
        vertices.add((id: descendantId, label: "$descendant"));

        for (Parser<void> child in descendant.children) {
          int childId = grabId(child);

          if (child.pegMemoize) {
            int dummyId = grabId(blank());

            /// Since this is a dummy node, add it to the graph.
            /// Note: this is necessary because terminal nodes are canonicalized,
            ///   so the graph is actually a forest, but that looks messy.
            if (child.isTerminal) {
              vertices.add((id: dummyId, label: "$child"));
            } else {
              vertices.add((id: dummyId, label: ruleName(childId)));

              ruleNodeIds.add(dummyId);
            }

            edges.add((from: descendantId, to: dummyId));
          } else {
            edges.add((from: descendantId, to: childId));
          }
        }

      }
    }

    return ((vertices: vertices, edges: edges), ruleNodeIds);
  }

  ///
  /// Using the [rules] method, generates a graphviz graph which
  /// separates the memoized parsers into different "rules",
  /// showing the connection between them.
  ///
  String generateRuleDotGraph({Map<int, String> ruleNames = const {}}) {
    if (_generateRuleGraph(ruleNames: ruleNames) case (Graph graph, Set<int> ids)) {
      return graph.generateDotFile({ for (int id in ids) id: {"shape": "box"}});
    }
  }

  Graph generateRuleGraph({Map<int, String> ruleNames = const {}}) {
    if (_generateRuleGraph(ruleNames: ruleNames) case (Graph graph, Set<int> ids)) {
      return graph;
    }
  }

  ///
  /// Generates graphviz graph that shows the relationship of
  /// all the parsers reachable from the root parser.
  ///
  String generateTrueDotGraph() {
    return _generateTrueGraph().generateDotFile();
  }
}
