import "package:parser_combinator/parser_combinator.dart";

Parser<R> _onFailure<R>(Parser<R> parser, R value) {
  return parser.pipe(
    (_, Context<R> result) => switch (result) {
      Failure failure => failure.success(value),
      Context<R> context => context,
    },
    toString: () => "OnFailureParser",
  );
}

extension OnFailureParserExtension<R> on Parser<R> {
  Parser<R> onFailure(R value) => _onFailure(this, value);
}
