import "package:parser_combinator/parser_combinator.dart";

Parser<List<R>> _cycleN<R>(Parser<R> parser, int n) {
  return parser.range(n, n);
}

extension CycleNExtension<R> on Parser<R> {
  Parser<List<R>> times(int n) => _cycleN(this, n);
  Parser<List<R>> operator *(int n) => _cycleN(this, n);
}
