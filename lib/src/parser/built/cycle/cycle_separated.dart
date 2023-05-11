import "package:parser_combinator/parser_combinator.dart";

Parser<List<R>> _separated<R>(Parser<R> parser, Parser<void> separator) {
  return sequence(<Parser<Object?>>[
    parser,
    sequence(<Parser<void>>[separator, parser]).map((List<void> c) => c[1] as R).star()
  ]).map((List<Object?> c) => <R>[c[0] as R, ...c[1]! as List<R>]);
}

extension CycleSeparatedExtension<R> on Parser<R> {
  Parser<List<R>> separated(Parser<void> separator) => _separated(this, separator);
  Parser<List<R>> operator %(Parser<void> separator) => separated(separator);
}
