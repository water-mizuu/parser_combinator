import "dart:convert";

import "package:parser_combinator/parser_combinator.dart";

final Map<String, Parser<String>> saved = <String, Parser<String>>{};
Parser<String> _string(String pattern) => saved[pattern] ??= predicate(
      (Context<void> context) => switch (context) {
        Context<void>(:String input, :int index) => switch (pattern.matchAsPrefix(input, index)) {
            Match(:int end) => context.success(pattern).replaceIndex(end),
            null => context.failure("Expected '$pattern'") as Context<String>,
          }
      },
      toString: () => jsonEncode(pattern),
      nullable: () => pattern.isEmpty,
    );

extension StringParserStringExtension on String {
  Parser<String> s() => _string(this);
}
