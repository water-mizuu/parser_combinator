import "package:meta/meta.dart";
import "package:parser_combinator/src/context/context.dart";

@optionalTypeArgs
@immutable
class Success<R> extends Context<R> {
  @override
  final R value;

  @override
  final Object? cst;

  @override
  String get message => throw UnsupportedError("`Success<$R>` does not have an error message!");

  const Success(this.value, [Object? cst, super.input = "", super.index = 0, super.indentation = const [0]])
      : cst = cst ?? value;

  @override
  R unwrap() => value;

  @override
  R tryUnwrap() => value;

  @override
  Success<R> replaceIndex(int index) => Success(value, cst, input, index, indentation);

  @override
  Success<R> replaceInput(String input) => Success<R>(value, cst, input, index, indentation);

  @override
  Success<R> inherit<I>(Context<I> context) =>
      Success<R>(value, cst, context.input, context.index, context.indentation);

  @override
  Success<R> pushIndent(int indent) => Success<R>(value, cst, input, index, [indent, ...indentation]);

  @override
  Success<R> popIndent() => Success<R>(value, cst, input, index, indentation.sublist(1));

  @override
  String toString() => "Success($location): $value";
}
