import "dart:convert";

import "package:parser_combinator/parser_combinator.dart";

Map<String, Parser<String>> _savedString = {};
Expando<Parser<String>> _savedRegExp = Expando();

Parser<String> _pattern(Pattern pattern) => predicate(
      (context) {
        Match? match = pattern.matchAsPrefix(context.input, context.index);
        if (match == null) {
          return context.failure("Expected '$pattern'");
        }

        return context.success(context.input.substring(match.start, match.end)).replaceIndex(match.end);
      },
      toString: pattern is String //
          ? () => jsonEncode(pattern)
          : () => "/${(pattern as RegExp).pattern}/",
      nullable: pattern is String //
          ? () => pattern.isEmpty
          : () => (pattern as RegExp).hasMatch(""),
    );
Parser<String> pattern(Pattern predicate) => predicate is String
    ? _savedString[predicate] ??= _pattern(predicate)
    : _savedRegExp[predicate] ??= _pattern(predicate);

extension PatternParserStringExtension on Pattern {
  Parser<String> p() => this == "" ? epsilon() : pattern(this);
}
