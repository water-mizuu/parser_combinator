import "package:parser_combinator/src/context.dart";
import "package:parser_combinator/src/extension/traverse.dart";
import "package:parser_combinator/src/parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";
import "package:parser_combinator/src/peg/handler/packrat/linear/typedef.dart";
import "package:parser_combinator/src/peg/handler/packrat/primitive/handler.dart";
import "package:parser_combinator/src/shared/default_map.dart";

class LinearHandler extends PegHandler {
  final ParsingTable _table = ParsingTable((_, __) => DefaultMap((_, __) => {}));

  LinearHandler();
  factory LinearHandler.tokenize(Parser<void> root, String input, [Pattern? layout]) {
    List<Parser<void>> terms = root.traverse().where((p) => p.children.isEmpty).toList();
    Parser<void> terminals = terms.choice().trimNewline(layout, layout).plus();

    PrimitiveHandler primitive = PrimitiveHandler();
    Context<void> result = terminals.pegParseOn(Context.empty(input), primitive);
    if (result is Failure) {
      throw Exception(result.generateFailureMessage());
    }
    LinearHandler self = LinearHandler();
    for (Parser<void> parser in terms) {
      for (int index in primitive.table[parser].keys) {
        for (int indent in primitive.table[parser][index].keys) {
          self._table[parser][index][indent] = primitive.table[parser][index][indent] ?? Context.empty();
        }
      }
    }

    return self;
  }

  Context<R> parseMemoized<R>(Parser<R> parser, Context<void> context) {
    int index = context.index;
    int indent = context.indentation.first;
    ParsingSubMap row = _table[parser];
    Context<R>? entry = row[index][indent] as Context<R>?;

    if (entry == null) {
      row[index][indent] = context.failure("seed");
      Context<R> ctx = row[index][indent] = parser.pegParseOn(context, this);
      if (ctx is Failure) {
        return ctx;
      }

      while (true) {
        Context<R> inner = parser.pegParseOn(context, this);
        if (inner is Failure || inner.index <= ctx.index) {
          return ctx;
        }
        ctx = row[index][indent] = inner;
      }
    } else {
      return entry;
    }
  }

  @override
  Context<R> parse<R>(Parser<R> parser, Context<void> context) => //
      context is Failure
          ? context.failure()
          : parser.pegMemoize //
              ? parseMemoized(parser, context)
              : parser.pegParseOn(context, this);
}
