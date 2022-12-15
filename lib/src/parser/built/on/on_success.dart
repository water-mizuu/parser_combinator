import "package:parser_combinator/parser_combinator.dart";

Parser<O> _onSuccess<R, O>(Parser<R> parser, O value) {
  return parser.pipe(
    (_, result) {
      if (result is Context<Never>) {
        return result;
      }
      return result.success(value);
    },
    toString: () => "OnSuccessParser",
  );
}

extension OnSuccessParserExtension<R> on Parser<R> {
  Parser<O> onSuccess<O>(O value) => _onSuccess(this, value);
}
