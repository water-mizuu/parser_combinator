import "package:parser_combinator/parser_combinator.dart";

extension PopIndentParser<R> on Parser<R> {
  Parser<R> popIndent() => pipe((_, context) => context.indentation.length > 1 ? context.popIndent() : context);
}
