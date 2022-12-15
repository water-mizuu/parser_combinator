import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/classes/head.dart";

class LeftRecursion<R> {
  final Parser<R> parser;
  Context<R> seed;
  Head<void>? head;

  LeftRecursion({required this.seed, required this.parser, required this.head});
}
