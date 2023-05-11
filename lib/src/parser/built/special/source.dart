import "package:parser_combinator/parser_combinator.dart";

final Parser<String> _anySingleton = predicate((Context<void> context) {
  String input = context.input;
  int index = context.index;

  return index < input.length //
      ? context.success(input[index]).replaceIndex(index + 1)
      : context.failure("Expected any character").cast();
}, toString: () => "any");

Parser<String> any() => _anySingleton;
