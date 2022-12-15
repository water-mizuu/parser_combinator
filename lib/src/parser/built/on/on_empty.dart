import "package:parser_combinator/parser_combinator.dart";

Parser<R> _onEmpty<R>(Parser<R> parser, R value) => parser.pipe(
      (_, result) {
        if (result is Empty) {
          return result.success(value);
        }
        return result;
      },
      toString: () => "OnEmptyParser",
    );

extension OnEmptyParserExtension<R> on Parser<R> {
  Parser<R> onEmpty(R value) => _onEmpty(this, value);
}
