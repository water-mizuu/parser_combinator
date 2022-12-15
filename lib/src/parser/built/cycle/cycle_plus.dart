import "package:parser_combinator/parser_combinator.dart";

Parser<List<R>> _cyclePlus<R>(Parser<R> parser) {
  return parser.range(1, double.infinity);
}

extension CyclePlusExtension<R> on Parser<R> {
  Parser<List<R>> plus() => _cyclePlus(this);
}
