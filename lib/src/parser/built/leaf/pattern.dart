import "dart:convert";

import "package:parser_combinator/parser_combinator.dart";

Map<String, Parser<String>> _savedString = {};
Expando<Parser<String>> _savedRegExp = Expando();

Parser<String> _pattern(Pattern pattern) => predicate(
      (context) =>
        switch (context) {
          Context(:String input, :int index) =>
            switch (pattern.matchAsPrefix(input, index)) {
              Match(:int start, :int end) => context.success(input.substring(start, end)).replaceIndex(end),
              // ignore: unnecessary_cast
              null => context.failure("Expected '/$pattern/'") as Context<String>,
            }
        },
      toString: pattern is String //
          ? () => jsonEncode(pattern)
          : () => "/${(pattern as RegExp).pattern}/",
      nullable: () => pattern.matchAsPrefix("") != null,
    );
Parser<String> pattern(Pattern predicate) => predicate is String
    ? _savedString[predicate] ??= _pattern(predicate)
    : _savedRegExp[predicate] ??= _pattern(predicate);

extension PatternParserStringExtension on Pattern {
  Parser<String> p() => this == "" ? epsilon() : pattern(this);
}
