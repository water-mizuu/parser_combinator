import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/context/failure.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

class ExceptParser<R> extends Parser<R> with WrappingParser<R, R> {
  @override
  final List<Parser<void>> children;
  Parser<void> get avoid => children[0];
  Parser<R> get parser => children[1] as Parser<R>;

  ExceptParser(Parser<R> child, Parser<void> avoid) : children = [avoid, child];
  ExceptParser._empty() : children = [];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    trampoline.add(avoid, context, (result) {
      if (result is Failure) {
        return trampoline.add(parser, context, continuation);
      } else {
        return continuation(context.failure("Except failure"));
      }
    });
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) {
    Context<void> result = handler.parse(avoid, context);

    if (result is Failure) {
      return handler.parse(parser, context);
    }
    return context.failure("Except failure");
  }

  @override
  ExceptParser<R> generateEmpty() {
    return ExceptParser._empty();
  }
}

extension ExceptParserExtension<R> on Parser<R> {
  Parser<R> except(Parser<void> avoid) => ExceptParser(this, avoid);
  Parser<R> operator -(Parser<void> avoid) => ExceptParser(this, avoid);
}
