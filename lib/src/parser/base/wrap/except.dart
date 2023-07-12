import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

base class ExceptParser<R> extends Parser<R> with WrappingParser<R, R> {
  @override
  final List<Parser<void>> children;
  Parser<void> get avoid => children[0];
  Parser<R> get parser => children[1] as Parser<R>;

  ExceptParser(Parser<R> child, Parser<void> avoid) : children = <Parser<void>>[avoid, child];
  ExceptParser._empty() : children = <Parser<void>>[];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    trampoline.add(avoid, context, (Context<void> result) {
      if (result case Failure _) {
        trampoline.add(parser, context, continuation);
      } else {
        continuation(context.failure("Except failure"));
      }
    });
    // trampoline.add(avoid, context, (result) =>
    //   switch (result) {
    //     Failure _ => trampoline.add(parser, context, continuation),
    //     _ => continuation(context.failure("Except failure")),
    //   });
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) => switch (handler.parse(avoid, context)) {
        Failure _ => handler.parse(parser, context),
        _ => context.failure("Except failure"),
      };

  @override
  ExceptParser<R> generateEmpty() {
    return ExceptParser<R>._empty();
  }
}

extension ExceptParserExtension<R> on Parser<R> {
  Parser<R> except(Parser<void> avoid) => ExceptParser<R>(this, avoid);
  Parser<R> operator -(Parser<void> avoid) => ExceptParser<R>(this, avoid);
}
