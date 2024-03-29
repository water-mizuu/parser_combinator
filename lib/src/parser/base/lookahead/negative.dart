import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

base class NegativeLookaheadParser<R> extends Parser<bool> with WrappingParser<bool, R> {
  @override
  final List<Parser<R>> children;
  Parser<R> get parser => children[0];

  NegativeLookaheadParser(Parser<R> child) : children = <Parser<R>>[child];
  NegativeLookaheadParser._empty() : children = <Parser<R>>[];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<bool> continuation) {
    trampoline.add(parser, context, (Context<R> result) {
      if (result is Failure) {
        return continuation(context.success(true));
      } else {
        return continuation(context.failure("Negative lookahead failure"));
      }
    });
  }

  @override
  Context<bool> pegParseOn(Context<void> context, PegHandler handler) {
    Context<R> result = handler.parse(parser, context);

    if (result is Failure) {
      return context.success(true);
    } else {
      return context.failure("Negative lookahead failure");
    }
  }

  @override
  NegativeLookaheadParser<R> generateEmpty() {
    return NegativeLookaheadParser<R>._empty();
  }
}

extension NegativeLookaheadParserExtension<R> on Parser<R> {
  Parser<bool> not() => NegativeLookaheadParser<R>(this);
}
