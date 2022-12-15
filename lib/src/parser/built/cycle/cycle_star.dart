import "package:parser_combinator/parser_combinator.dart";

Parser<List<R>> _cycleStar<R>(Parser<R> parser) {
  return parser.range(0, double.infinity);
}

extension CycleStarExtension<R> on Parser<R> {
  Parser<List<R>> star() => _cycleStar(this);
}
