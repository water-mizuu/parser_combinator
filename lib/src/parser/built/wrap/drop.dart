import "package:parser_combinator/parser_combinator.dart";

Parser<Never> _drop(Parser<void> parser) {
  return parser.bind(
    <Parser<void>>[empty<Never>()],
    (List<Parser<void>> $, _) => $[0].cast(),
  );
}

extension DropParserExtension<R> on Parser<R> {
  Parser<Never> drop() => _drop(this);
}
