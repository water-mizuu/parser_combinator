import "package:parser_combinator/parser_combinator.dart";

Parser<C> _then<C>(Parser<C> parser, ThenParserFunction<C> visitor) {
  return parser.pipe(toString: () => "ThenParser", (_, Context<C> context) {
    if (context is Success<C>) {
      visitor(context.value);
    }
    return context;
  });
}

extension ThenParser<C> on Parser<C> {
  Parser<C> then(ThenParserFunction<C> function) => _then(this, function);
}
