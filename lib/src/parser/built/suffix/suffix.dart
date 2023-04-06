import "package:parser_combinator/parser_combinator.dart";

Parser<R> _suffix<R>(Parser<R> parser, Parser<void> suffix) {
  return sequence([parser, suffix]).map((r) => r[0] as R);
}

extension PostfixParserExtension<R> on Parser<R> {
  Parser<R> suffix(Parser<void> suffix) => _suffix(this, suffix);
}
