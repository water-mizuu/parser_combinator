import "package:parser_combinator/parser_combinator.dart";

Parser<R> _message<R>(Parser<R> parser, String message) {
  return parser.pipe(
    (_, result) {
      if (result is Failure) {
        return result.failure(message);
      }
      return result;
    },
    toString: () => "MessageParser",
  );
}

extension MessageParserExtension<R> on Parser<R> {
  Parser<R> message(String message) => _message(this, message);
}
