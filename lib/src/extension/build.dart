import "package:parser_combinator/parser_combinator.dart";

final Expando<Parser<void>> _builtParsers = Expando<Parser<void>>();
Parser<R> _build<R>(Parser<R> parser) => (_builtParsers[parser] ??= () {
      Parser<R> clone = parser.selfClone();
      clone.selfTransform(<R>(parser) {
        if (parser is ReferenceParser<R>) {
          return parser.computed..pegMemoize = true;
        }
        return parser;
      });
      Parser<R> root = clone is ReferenceParser<R> //
          ? (clone.computed..pegMemoize = true)
          : clone;

      return root;
    }()) as Parser<R>;

extension LazyParserBuildExtension<R> on Lazy<Parser<R>> {
  ///
  /// Wraps the `Parser<R> Function()` into a [ReferenceParser],
  /// calling `.build()` after.
  ///
  Parser<R> build() => _build(ReferenceParser<R>(this));
}

extension ParserBuildExtension<R> on Parser<R> {
  ///
  /// Immutably traverses all the parsers reachable from the root,
  /// replacing all [ReferenceParser]s with their computed children,
  /// flagging them as memoized in the process.
  ///
  Parser<R> build() => _build(this);
}
