import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

// class Head<R> {
//   final Parser<R> parser;
//   final Set<Parser<void>> involvedSet;
//   final Set<Parser<void>> evaluationSet;

//   Head({required this.parser, required this.involvedSet, required this.evaluationSet});
// }

typedef Head<R> = ({Parser<R> parser, Set<Parser<void>> involvedSet, Set<Parser<void>> evaluationSet});
