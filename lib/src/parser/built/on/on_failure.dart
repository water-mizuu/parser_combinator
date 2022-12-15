import "package:parser_combinator/parser_combinator.dart";

Parser<R> _onFailure<R>(Parser<R> parser, R value) => parser.pipe(
      (_, result) {
        if (result is Failure) {
          return result.success(value);
        }
        return result;
      },
      toString: () => "OnFailureParser",
    );

extension OnFailureParserExtension<R> on Parser<R> {
  Parser<R> onFailure(R value) => _onFailure(this, value);
}
