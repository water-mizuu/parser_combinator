import "package:parser_combinator/parser_combinator.dart";

Parser<R?> _optional<R>(Parser<R> parser) {
  return <Parser<R?>>[parser, success(null)].firstChoice();
}

extension OptionalParserExtension<R> on Parser<R> {
  Parser<R?> optional() => _optional(this);
}
