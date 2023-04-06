import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/action.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

///
/// A [ParserAction] that executes a `call` action.
///
class CallAction<R> implements ParserAction {
  final Parser<R> parser;
  final Context<void> context;
  final Continuation<R> continuation;

  const CallAction(this.parser, this.context, this.continuation);
  // const CallAction(Parser<R> parser, Context<void> context, Continuation<R> continuation)
  //     : parser = parser,
  //       context = context,
  //       continuation = continuation;
  // CallAction(Parser<R> parser, Context<void> context, Continuation<R> continuation) {
  //   this.parser = parser;
  //   this.context = context;
  //   this.continuation = continuation;
  // }

  @override
  void call(Trampoline trampoline) {
    parser.gllParseOn(context, trampoline, continuation);
  }
}
