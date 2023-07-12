import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

base mixin UnitedParser<R> on Parser<R> {
  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    // return trampoline.add(, context, continuation);
    return continuation(parseOn(context));
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) {
    return parseOn(context);
  }

  Context<R> parseOn(Context<void> context);
}
