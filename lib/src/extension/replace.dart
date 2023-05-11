import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

extension ParserReplaceExtension<R> on Parser<R> {
  ///
  /// Mutates all reachable parsers, replacing parsers that
  /// match [target] with [replacement].
  ///
  Parser<R> replace<O extends Object?>(Parser<O> target, Parser<O> replacement) =>
      selfTransform(<R>(Parser<R> t) => t == target ? replacement as Parser<R> : t);

  ///
  /// First creates a copy of all the parsers reachable from the root,
  /// then replaces the parsers that match [target] with [replacement].
  ///
  Parser<R> replaced<O extends Object?>(Parser<O> target, Parser<O> replacement) =>
      selfClone().replace(target, replacement);
}
