import "package:parser_combinator/parser_combinator.dart";

Parser<R> _surrounded<R>(Parser<R> parser, Parser<void> left, Parser<void> right) {
  return sequence([left, parser, right]).map((r) => r[1] as R);
}

extension SurroundedParserExtension<R> on Parser<R> {
  Parser<R> between(Parser<void> left, Parser<void> right) => _surrounded(this, left, right);
  Parser<R> surrounded(Parser<void> left, Parser<void> right) => _surrounded(this, left, right);
  Parser<R> surroundedBy(Parser<void> left, {required Parser<void> and}) => _surrounded(this, left, and);
}
