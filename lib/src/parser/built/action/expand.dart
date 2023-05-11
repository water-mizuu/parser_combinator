import "package:parser_combinator/parser_combinator.dart";

Parser<R> _expand<R, C>(Parser<C> parser, ExpandedParserFunction<R, C> visitor) {
  return parser.pipe(toString: () => "ExpandedParser", (_, Context<C> context) {
    if (context is Success<C>) {
      return visitor(context.value).inherit(context);
    }
    return context as Context<Never>;
  });
}

extension ExpandedParser<C> on Parser<C> {
  Parser<R> expand<R>(ExpandedParserFunction<R, C> function) => _expand(this, function);
}
