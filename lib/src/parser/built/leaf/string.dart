import "dart:convert";

import "package:parser_combinator/parser_combinator.dart";

final Map<String, Parser<String>> saved = {};
Parser<String> _string(String pattern) => saved[pattern] ??= predicate(
      (context) {
        Match? match = pattern.matchAsPrefix(context.input, context.index);
        if (match == null) {
          return context.failure("Expected '$pattern'");
        }

        return context.success(pattern).replaceIndex(match.end);
      },
      toString: () => jsonEncode(pattern),
      nullable: () => pattern.isEmpty,
    );

extension StringParserStringExtension on String {
  Parser<String> s() => _string(this);
}
