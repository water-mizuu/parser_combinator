import "package:parser_combinator/parser_combinator.dart";

final RegExp _pattern = RegExp(r"(?:(?!\n)\s)*");

Parser<R> _trim<R>(Parser<R> parser, [Pattern? left, Pattern? right]) =>
    trimmingParser(parser, left ?? _pattern, right ?? _pattern);

Parser<R> _trimLeft<R>(Parser<R> parser, [Pattern? left]) => trimmingParser(parser, left ?? _pattern, null);
Parser<R> _trimRight<R>(Parser<R> parser, [Pattern? right]) => trimmingParser(parser, null, right ?? _pattern);

extension ParserTrimExtension<R> on Parser<R> {
  Parser<R> trim([Pattern? left, Pattern? right]) => _trim(this, left, right);
  Parser<R> trimLeft([Pattern? left]) => _trimLeft(this, left);
  Parser<R> trimRight([Pattern? right]) => _trimRight(this, right);

  Parser<R> t([Pattern? left, Pattern? right]) => _trim(this, left, right);
  Parser<R> tl([Pattern? left]) => _trimLeft(this, left);
  Parser<R> tr([Pattern? right]) => _trimRight(this, right);
}
