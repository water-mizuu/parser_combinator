import "package:parser_combinator/parser_combinator.dart";

/// Parser that returns a [bool] that indicates whether a
/// [RegExp] string is nullable.
Parser<bool> regexNullableParser() => _expr();

Parser<bool> _expr() => _alt.$().between("^".s().optional().start(), r"$".s().optional().end());

Parser<bool> _alt() =>
    (_sequence.$(), "|".s(), _alt.$()).sequence().map(((bool, void, bool) $) => $.$1 || $.$3) / //
    (_sequence.$());

Parser<bool> _sequence() =>
    (_opt.$(), _sequence.$()).sequence().map(((bool, bool) $) => $.$1 && $.$2) / //
    _opt.$();

Parser<bool> _opt() =>
    (_post.$(), "?".s()).sequence().map(((bool, String) $) => true) / //
    _post.$();

Parser<bool> _post() => choice.builder(() sync* {
      Parser<bool> quantifiable = _atom.$();

      yield quantifiable.suffix("+".s());
      yield quantifiable.suffix("*".s()).map((_) => true);

      yield _integer().suffix(",".s() & _integer().optional()).between("{".s(), "}".s()).prefix(quantifiable);

      yield _integer().between("{".s(), "}".s()).prefix(quantifiable);

      yield quantifiable;
    });

Parser<Object> _range() => _rangeUnit.$().plus();
Parser<Object> _rangeUnit() =>
    (_rangeChar.$(), "-".s(), _rangeChar.$()).sequence().where(((String, void, String) $) {
      var (String low, _, String high) = $;

      return int.parse(low) <= int.parse(high);
    }, messageBuilder: ((String, void, String) $) {
      var (String(unit: int low), _, String(unit: int high)) = $;

      return "Expected a valid range. (Received $low to $high)";
    }) |
    _escChar.$() |
    _boundChar.$(); //

Parser<String> _boundChar() => any().prefix(r"\".s()) / any().except("]".s());
Parser<String> _rangeChar() => any().except(<String>["]", "-"].map(string).firstChoice());
Parser<bool> _atom() => choice.builder(() sync* {
      yield _range.$().between("[^".s() / "[".s(), "]".s()).map((Object $) => false);
      yield _alt.$().between(<String>["(", "(?:"].trie(), ")".s());

      /// Positive lookahead
      yield _alt.$().between(<String>["(?=", "(?!", "(?<=", "(?<!"].trie(), ")".s()).map((bool $) => true);
      yield _escChar.$();
      yield _char.$();
    });

Parser<bool> _escChar() => any().onFailure("").prefix(r"\".s()).map((String $) => $.isEmpty);
Parser<bool> _char() => any()
    .except(const <String>[
      ...<String>["(", ")", "[", "]", "{", "}"],
      ...<String>["(?:", "(?=", "(?!", "(?<=", "(?<!", "[^"],
      ...<String>[",", "|", "*", "+", "?", r"\", r"$"],
    ].trie())
    .map((_) => false);

Parser<bool> _integer() => codeRange("0".unit, "9".unit).plus().flat().map((String v) => int.parse(v) > 0);
