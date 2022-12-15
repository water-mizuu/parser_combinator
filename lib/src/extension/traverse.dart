import "dart:collection";

import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

extension ParserTraverseExtension<R> on Parser<R> {
  ///
  /// Traverses all parsers reachable breadth-first from the root.
  /// Passes through references.
  ///
  Iterable<Parser<void>> traverse() sync* {
    Set<Parser<void>> traversed = Set<Parser<void>>.identity()..add(this);
    Queue<Parser<void>> parsers = Queue<Parser<void>>()..add(this);

    while (parsers.isNotEmpty) {
      Parser<void> current = parsers.removeFirst();
      traversed.add(current);
      yield current;

      for (Parser<void> child in current.children) {
        if (traversed.add(child)) {
          parsers.add(child);
        }
      }
    }
  }

  ///
  /// Traverses all parsers reachable breadth-first from the root.
  /// Does not pass through references. (Direct descendants)
  ///
  Iterable<Parser<void>> traverseShallow() sync* {
    Set<Parser<void>> traversed = Set<Parser<void>>.identity()..add(this);
    Queue<Parser<void>> parsers = Queue<Parser<void>>()..add(this);

    while (parsers.isNotEmpty) {
      Parser<void> current = parsers.removeFirst();
      traversed.add(current);
      yield current;

      for (Parser<void> child in current.children) {
        if (child.pegMemoize && child.isNotTerminal || !traversed.add(child)) {
          continue;
        }

        parsers.add(child);
      }
    }
  }
}
