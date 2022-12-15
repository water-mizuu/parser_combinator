import "package:parser_combinator/parser_combinator.dart";

Parser<List<R>> _separated<R>(Parser<R> parser, Parser<void> separator) {
  return sequence([
    parser,
    sequence([separator, parser]).map((c) => c[1] as R).star()
  ]).map((c) => [c[0] as R, ...c[1]! as List<R>]);
}

extension CycleSeparatedExtension<R> on Parser<R> {
  Parser<List<R>> separated(Parser<void> separator) => _separated(this, separator);
  Parser<List<R>> operator %(Parser<void> separator) => separated(separator);
}
