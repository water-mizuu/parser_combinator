part of "context.dart";

@optionalTypeArgs
@immutable
class Empty extends Context<Never> {
  @override
  Never get value => throw UnsupportedError("`Empty` does not have a result!");

  @override
  Never get message => throw UnsupportedError("`Empty` does not have a result!");

  @override
  final Object? cst;

  const Empty([this.cst, super.input = "", super.index = 0, super.indentation = const <int>[0]]);

  @override
  Never unwrap() => throw UnsupportedError("`Empty` cannot be unwrapped!");

  @override
  Null tryUnwrap() => null;

  @override
  Empty replaceIndex(int index) => Empty(cst, input, index, indentation);

  @override
  Empty replaceInput(String input) => Empty(cst, input, index, indentation);

  @override
  Empty inherit<I>(Context<I> context) => Empty(cst, context.input, context.index, context.indentation);

  @override
  Empty pushIndent(int indent) => Empty(cst, input, index, <int>[indent, ...indentation]);

  @override
  Empty popIndent() => Empty(cst, input, index, indentation.sublist(1));

  @override
  String toString() => "Empty($location)";
}
