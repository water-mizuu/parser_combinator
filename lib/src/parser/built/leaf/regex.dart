import "dart:collection";

import "package:parser_combinator/parser_combinator.dart";

final HashMap<String, RegExp> _savedRegExp = HashMap<String, RegExp>();
final HashMap<String, Parser<String>> _savedRegExpParser = HashMap<String, Parser<String>>();

Parser<String> regex(
  String pattern, {
  bool multiLine = false,
  bool caseSensitive = true,
  bool unicode = false,
  bool dotAll = false,
}) {
  RegExp regex = _savedRegExp.putIfAbsent(
      pattern,
      () => RegExp(
            pattern,
            multiLine: multiLine,
            caseSensitive: caseSensitive,
            unicode: unicode,
            dotAll: dotAll,
          ));

  return _savedRegExpParser[pattern] ??= predicate(
    (Context<void> context) => switch (context) {
      Context<void>(:String input, :int index) => switch (regex.matchAsPrefix(input, index)) {
          Match match => context.success(match.group(0)!).replaceIndex(match.end),
          // ignore: unnecessary_cast
          null => context.failure("Expected '/$pattern/'") as Context<String>,
        }
    },
    toString: () => "/$pattern/",
    nullable: () => regex.hasMatch(""),
  );
}

extension RegexParserStringExtension on String {
  Parser<String> r({
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) =>
      regex(
        this,
        multiLine: multiLine,
        caseSensitive: caseSensitive,
        unicode: unicode,
        dotAll: dotAll,
      );
}
