import "package:parser_combinator/parser_combinator.dart";

Parser<R> _prefix<R>(Parser<R> parser, Parser<void> prefix) {
  return sequence(<Parser<void>>[prefix, parser]).map((List<void> r) => r[1] as R);
}

extension PrefixParserExtension<R> on Parser<R> {
  Parser<R> prefix(Parser<void> prefix, {void prefixExtension}) => _prefix(this, prefix);
}

extension PrefixParserNotExtension<R> on Parser<R> Function(Parser<void> prefix, {void prefixExtension}) {
  Parser<R> not(Parser<void> prefix) => this(prefix.not());
}
