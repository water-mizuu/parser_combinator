import "package:parser_combinator/parser_combinator.dart";

Parser<R> _prefix<R>(Parser<R> parser, Parser<void> prefix) {
  return sequence([prefix, parser]).map((r) => r[1] as R);
}

extension PrefixParserExtension<R> on Parser<R> {
  Parser<R> prefix(Parser<void> prefix) => _prefix(this, prefix);
}
