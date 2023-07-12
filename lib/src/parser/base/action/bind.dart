import "package:parser_combinator/src/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";
import "package:parser_combinator/src/shared/typedef.dart";

///
/// Allows returning a [Parser] depending on the result
/// of the [Context] after parsing with [child].
///
base class BoundParser<R, C> extends Parser<R> with WrappingParser<R, C> {
  final String Function()? _toString;

  ///
  /// Flag that determines if the parser is nullable.
  ///
  final bool nullable;

  @override
  final List<Parser<void>> children;
  final BoundParserFunction<R, C> function;

  BoundParser(
    Parser<C> child,
    List<Parser<void>> children,
    this.function, {
    this.nullable = false,
    String Function()? toString,
  })  : children = <Parser<void>>[child, ...children],
        _toString = toString;
  BoundParser._empty(
    this.function, {
    required this.nullable,
    required String Function()? toString,
  })  : children = <Parser<void>>[],
        _toString = toString;

  Parser<R> callBound(Context<C> context) {
    Parser<R> bound = function(children.sublist(1), context);
    assert(children.contains(bound), "The parser of a BoundParser must be a member of its children!");

    return bound;
  }

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    return trampoline.add(child, context, (Context<C> result) {
      if (result is Failure) {
        return continuation(result);
      } else {
        Parser<R> parser = callBound(result);

        return trampoline.add(parser, result, continuation);
      }
    });
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) {
    Context<C> result = handler.parse(child, context);
    if (result is Failure) {
      return result;
    } else {
      Parser<R> parser = callBound(result);

      return handler.parse(parser, result);
    }
  }

  @override
  BoundParser<R, C> generateEmpty() {
    return BoundParser<R, C>._empty(function, nullable: nullable, toString: _toString);
  }

  @override
  String toString() => _toString?.call() ?? super.toString();
}

extension BoundParserExtension<C> on Parser<C> {
  ///
  /// Binds a parser with a [BoundParser].
  ///
  Parser<R> bind<R>(
    List<Parser<void>> children,
    BoundParserFunction<R, C> function, {
    bool nullable = false,
    String Function()? toString,
  }) =>
      BoundParser<R, C>(
        this,
        children,
        function,
        nullable: nullable,
        toString: toString,
      );
}
