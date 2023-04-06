import "package:parser_combinator/src/parser.dart";

Parser<R> trimmingParser<R>(Parser<R> parser, [Pattern? left, Pattern? right]) {
  return parser.surrounded(pattern(left ?? ""), pattern(right ?? left ?? ""));
}
