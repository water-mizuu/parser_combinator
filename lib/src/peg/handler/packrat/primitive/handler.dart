import "package:parser_combinator/src/context.dart";
import "package:parser_combinator/src/extension/traverse.dart";
import "package:parser_combinator/src/parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";
import "package:parser_combinator/src/peg/handler/packrat/linear/typedef.dart";

class PrimitiveHandler extends PegHandler {
  PrimitiveHandler();
  factory PrimitiveHandler.tokenize(Parser<void> root, String input, [Pattern? layout]) {
    List<Parser<void>> terms = root.traverse().where((Parser<void> p) => p.isTerminal && p.isNotNullable).toList();
    Parser<List<void>> terminals = terms.choice().trimNewline(layout, layout).plus();

    PrimitiveHandler handler = PrimitiveHandler();
    Context<List<void>> result = terminals.pegParseOn(Context<void>.empty(input), handler);
    if (result is Failure) {
      throw Exception(result.generateFailureMessage());
    }

    return handler;
  }

  final ParsingTable table = createParsingTable();

  Context<R> parseMemoized<R>(Parser<R> parser, Context<void> context) {
    int index = context.index;
    int indent = context.indentation.first;

    ParsingSubMap row = table[parser];
    Context<R>? saved = row[index][indent] as Context<R>?;

    if (saved == null) {
      row[index][indent] = context.failure("Left recursion");
      Context<R> result = parser.pegParseOn(context, this);
      row[index][indent] = result;

      return result;
    } else {
      return saved;
    }
  }

  @override
  Context<R> parse<R>(Parser<R> parser, Context<void> context) {
    return context is Failure //
        ? context
        : parser.pegMemoize
            ? parseMemoized(parser, context)
            : parser.pegParseOn(context, this);
  }
}
