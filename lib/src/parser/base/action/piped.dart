import "package:parser_combinator/src/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";
import "package:parser_combinator/src/shared/typedef.dart";

class PipedParser<R, C> extends Parser<R> with WrappingParser<R, C> {
  final String Function()? _toString;

  @override
  final List<Parser<C>> children;
  final PipedParserFunction<R, C> function;

  PipedParser(Parser<C> child, this.function, {String Function()? toString})
      : children = [child],
        _toString = toString;
  PipedParser._empty(this.function, {required String Function()? toString})
      : children = [],
        _toString = toString;

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    return trampoline.add(child, context, (result) {
      return continuation(function(context, result));
    });
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) {
    Context<C> result = handler.parse(child, context);

    return function(context, result);
  }

  @override
  PipedParser<R, C> generateEmpty() {
    return PipedParser<R, C>._empty(function, toString: _toString);
  }

  @override
  String toString() => _toString?.call() ?? super.toString();
}

extension PipedParserExtension<C> on Parser<C> {
  ///
  /// Pipes a parser with a [PipedParser].
  ///
  Parser<R> pipe<R>(PipedParserFunction<R, C> function, {String Function()? toString}) =>
      PipedParser<R, C>(this, function, toString: toString);

  ///
  /// Only pipes the parser when the result is a [Success].
  ///
  Parser<R> pipeSuccess<R>(PipedParserFunction<R, C> function, {String Function()? toString}) =>
      PipedParser<R, C>(this, (from, to) {
        if (to case Success<C>()) {
          return function(from, to);
        } else {
          return to as Context<Never>;
        }
      }, toString: toString);
}
