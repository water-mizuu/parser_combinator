import "package:parser_combinator/parser_combinator.dart";

Parser<R> _onEmpty<R>(Parser<R> parser, R value) {
  return parser.pipe(
    (_, Context<R> result) => switch (result) {
      Empty result => result.success(value),
      Context<R> result => result,
    },
    toString: () => "OnEmptyParser",
  );
}

extension OnEmptyParserExtension<R> on Parser<R> {
  Parser<R> onEmpty(R value) => _onEmpty(this, value);
}
