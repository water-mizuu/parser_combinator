import "dart:collection";

import "package:parser_combinator/parser_combinator.dart";

HashMap<String, RegExp> _savedRegExp = HashMap<String, RegExp>();
HashMap<String, Parser<String>> _savedRegExpParser = HashMap<String, Parser<String>>();

Parser<String> regex(String pattern) {
  RegExp regex = _savedRegExp.putIfAbsent(pattern, () => RegExp(pattern, unicode: true));

  return _savedRegExpParser[pattern] ??= predicate(
    (context) {
      Match? match = regex.matchAsPrefix(context.input, context.index);
      if (match == null) {
        return context.failure("Expected '$pattern'");
      }

      return context //
          .success(match.groups([0])[0]!)
          .replaceIndex(match.end);
    },
    toString: () => "/$pattern/",
    nullable: () => regex.hasMatch(""),
  );
}

extension RegexParserStringExtension on String {
  Parser<String> r() => regex(this);
}
