import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

base class PositiveLookaheadParser<R> extends Parser<bool> with WrappingParser<bool, R> {
  @override
  final List<Parser<R>> children;
  Parser<R> get parser => children[0];

  PositiveLookaheadParser(Parser<R> child) : children = <Parser<R>>[child];
  PositiveLookaheadParser._empty() : children = <Parser<R>>[];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<bool> continuation) {
    trampoline.add(parser, context, (Context<R> result) {
      if (result is Failure) {
        return continuation(result);
      } else {
        return continuation(context.success(true));
      }
    });
  }

  @override
  Context<bool> pegParseOn(Context<void> context, PegHandler handler) => switch (handler.parse(parser, context)) {
        Failure failure => failure as Context<bool>,
        Context<void> context => context.success(true),
      };

  @override
  PositiveLookaheadParser<R> generateEmpty() => PositiveLookaheadParser<R>._empty();
}

extension PositiveLookaheadParserExtension<R> on Parser<R> {
  Parser<bool> and() => PositiveLookaheadParser<R>(this);
}
