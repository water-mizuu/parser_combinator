import "package:parser_combinator/parser_combinator.dart";

final RegExp _pattern = RegExp(r"\s*");

Parser<R> _trimNewline<R>(Parser<R> parser, [Pattern? left, Pattern? right]) =>
    trimmingParser(parser, left ?? _pattern, right ?? _pattern);

Parser<R> _trimNewlineLeft<R>(Parser<R> parser, [Pattern? left]) => trimmingParser(parser, left ?? _pattern, null);
Parser<R> _trimNewlineRight<R>(Parser<R> parser, [Pattern? right]) => trimmingParser(parser, null, right ?? _pattern);

extension ParserTrimNewlineExtension<R> on Parser<R> {
  Parser<R> trimNewline([Pattern? left, Pattern? right]) => _trimNewline(this, left, right);
  Parser<R> trimNewlineLeft([Pattern? left]) => _trimNewlineLeft(this, left);
  Parser<R> trimNewlineRight([Pattern? right]) => _trimNewlineRight(this, right);

  Parser<R> tnl([Pattern? left, Pattern? right]) => _trimNewline(this, left, right);
  Parser<R> tnlL([Pattern? left]) => _trimNewlineLeft(this, left);
  Parser<R> tnlR([Pattern? right]) => _trimNewlineRight(this, right);
}
