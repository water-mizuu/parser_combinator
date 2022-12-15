import "package:parser_combinator/parser_combinator.dart";

extension ParserRulesExtension<R> on Parser<R> {
  ///
  /// Traverses all reachable parsers from the root,
  /// yielding the parsers that passes the following checks:
  /// - Is memoized (referenced somewhere else)
  /// - Is not terminal (has children).
  ///
  Iterable<Parser<void>> rules() sync* {
    for (Parser<void> parser in build().traverse()) {
      if (parser.pegMemoize && parser.isNotTerminal) {
        yield parser;
      }
    }
  }
}
