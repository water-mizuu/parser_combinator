import "package:parser_combinator/parser_combinator.dart";

/// Parser that returns a [bool] that indicates whether a
/// [RegExp] string is nullable.
Parser<bool> regexNullableParser() => _expr();

Parser<bool> _expr() => _alt.$().between("^".s().optional().start(), r"$".s().optional().end());
Parser<bool> _alt() => (_sequence.$(), _sequence.$().prefix("|".s()).star()).sequence().map(($) => switch ($) {
      (bool first, List<bool> rest) => first || rest.fold(false, (a, b) => a || b),
    });

Parser<bool> _sequence() => (_opt.$(), _opt.$().star()).sequence().map(($) => switch ($) {
      (bool first, List<bool> rest) => first && rest.fold(true, (a, b) => a && b), //
    });

Parser<bool> _opt() => (_post.$(), "?".s().optional()).sequence().map(($) => $.$1 || $.$2 != null);

Parser<bool> _post() => choice.builder(() sync* {
      Parser<bool> quantifiable = _atom.$();

      yield quantifiable.suffix("+".s());
      yield quantifiable.suffix("*".s()).map((_) => true);

      yield integer().suffix(",".s() & integer().optional()).between("{".s(), "}".s()).prefix(quantifiable);

      yield integer().between("{".s(), "}".s()).prefix(quantifiable);

      yield quantifiable;
    });

Parser<Object> _range() => _rangeUnit.$().plus();
Parser<Object> _rangeUnit() =>
    (_rangeChar.$(), "-".s(), _rangeChar.$()).sequence().where(($) {
      var (String low, _, String high) = $;

      return int.parse(low) <= int.parse(high);
    }, messageBuilder: ($) {
      var (String low, _, String high) = $;

      return "Expected a valid range. (Received ${low.unit} to ${high.unit})";
    }) |
    _escChar.$() |
    _boundChar.$(); //

Parser<String> _boundChar() => any().prefix(r"\".s()) / any().except("]".s());
Parser<String> _rangeChar() => any().except(["]", "-"].map(string).firstChoice());
Parser<bool> _atom() => choice.builder(() sync* {
      yield _range.$().between("[^".s() / "[".s(), "]".s()).map(($) => false);
      yield _alt.$().between(["(", "(?:"].trie(), ")".s());

      // Positive lookahead
      yield _alt.$().between(["(?=", "(?!", "(?<=", "(?<!"].trie(), ")".s()).map(($) => true);
      yield _escChar.$();
      yield _char.$();
    });

Parser<bool> _escChar() => any().onFailure("").prefix(r"\".s()).map(($) => $.isEmpty);
Parser<bool> _char() => any()
    .except([
      ...["(", ")", "[", "]", "{", "}"],
      ...["(?:", "(?=", "(?!", "(?<=", "(?<!", "[^"],
      ...[",", "|", "*", "+", "?", r"\", r"$"],
    ].trie())
    .map(($) => false);

Parser<bool> integer() => codeRange("0".unit, "9".unit).plus().flat().map((v) => int.parse(v) > 0);
