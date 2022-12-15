import "package:parser_combinator/parser_combinator.dart";

Parser<R> _transformed<R>(Parser<R> parser, TransformFunction handler) {
  Parser<R> clone = parser.selfClone();

  return clone.selfTransform(handler);
}

extension ParserTransformedExtension<R> on Parser<R> {
  ///
  /// Clones the root parser first, finally applying `.transform` after.
  ///
  Parser<R> transformed(TransformFunction handler) => _transformed(this, handler);
}
