import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/special/context_predicate.dart";

final Map<(int, int), Parser<String>> _saved = <(int, int), Parser<String>>{};
Parser<String> _codeRange(int low, int high) => predicate(
      (Context<void> context) {
        var Context<void>(:String input, :int index) = context;
        if (index >= input.length) {
          return context.failure("Unexpected end of input.");
        }

        int codeUnit = input.codeUnitAt(index);
        if (low <= codeUnit && codeUnit <= high) {
          return context.success(input[index]).replaceIndex(index + 1);
        }
        return context.failure("Expected any code unit between $low and $high.");
      },
      toString: () => "CodeRangeParser",
      nullable: () => false,
    );

Parser<String> codeRange(int low, int high) => _saved //
    .putIfAbsent((low, high), () => _codeRange(low, high));

extension StringCodeUnitExtension on String {
  int get unit => codeUnitAt(0);
}
