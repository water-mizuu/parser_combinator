import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/childless_parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/united_parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

base class ContextPredicateParser<R> extends Parser<R> with UnitedParser<R>, ChildlessParser<R> {
  final String Function()? _toString;
  final bool Function()? _nullable;

  final ContextPredicateFunction<R> predicate;

  ContextPredicateParser(
    this.predicate, {
    bool Function()? nullable,
    String Function()? toString,
  })  : _toString = toString,
        _nullable = nullable;

  @override
  Context<R> parseOn(Context<void> context) => predicate(context);

  @override
  bool get pegMemoize => true;

  @override
  String toString() => _toString?.call() ?? super.toString();

  @override
  late final bool nullable = _nullable?.call() ?? true;
}

Parser<R> predicate<R>(
  ContextPredicateFunction<R> predicate, {
  bool Function()? nullable,
  String Function()? toString,
}) =>
    ContextPredicateParser<R>(predicate, nullable: nullable, toString: toString);
