
import "package:parser_combinator/parser_combinator.dart";


/// Parser that returns a [bool] that indicates whether a
/// [RegExp] string is nullable.
Parser<bool> regexNullableParser() => _expr();

Parser<bool> _expr() => _alt.$().surrounded("^".s().optional().start(), r"$".s().optional().end());
Parser<bool> _alt() =>
    (_sequence.$(), ("|".s(), _sequence.$()).sequence().map(($) => $.$1).star()).sequence().map(($) {
      return $.$0 || $.$1.fold(false, (a, b) => a || b);
    });

Parser<bool> _sequence() =>
    (_opt.$(), _opt.$().star()).sequence().map(($) {
      return $.$0 && $.$1.fold(true, (a, b) => a && b);
    });

Parser<bool> _opt() =>
    (_post.$(), "?".s().optional()).sequence().map(($) => $.$0 || $.$1 != null);

Parser<bool> _post() => choice.builder(() sync* {
      Parser<bool> quantifiable = _atom.$();

      yield quantifiable.suffix("+".s());
      yield quantifiable.suffix("*".s()).map((_) => true);

      yield integer()
          .suffix(",".s())
          .suffix(integer())
          .surrounded("{".s(), "}".s())
          .prefix(quantifiable);

      yield integer()
          .suffix(",".s())
          .surrounded("{".s(), "}".s())
          .prefix(quantifiable);

      yield integer().surrounded("{".s(), "}".s()).prefix(quantifiable);

      yield quantifiable;
    });

Parser<Object> _range() => _rangeUnit.$().plus();
Parser<Object> _rangeUnit() =>
    (_rangeChar.$(), "-".s(), _rangeChar.$()).sequence().where(($) {
      if ($ case [int low, _, int high]) {
        return low <= high;
      }
      return false;
    }, messageBuilder: ($) {
      if ($ case (String low, String high)) {
        return "Expected a valid range. (Received ${low.unit} to ${high.unit})";
      }
      return "";
    }) |
    _escChar.$() |
    _boundChar.$(); //

Parser<String> _boundChar() => any().prefix(r"\".s()) / any().except("]".s());
Parser<String> _rangeChar() => any().except(["]",  "-"].map(string).firstChoice());
Parser<bool> _atom() => choice.builder(() sync* {
      yield _range.$().surrounded("[^".s() / "[".s(), "]".s()).map(($) => false);
      yield _alt.$().surrounded(["(", "(?:"].trie(), ")".s());

      // Positive lookahead
      yield _alt.$().surrounded("(?".s() & ["=", "!", "<=", "<!"].trie(), ")".s()).map(($) => true);
      yield _escChar.$();
      yield _char.$();
    });

Parser<bool> _escChar() => any().onFailure("").prefix(r"\".s()).map(($) => $.isEmpty);
Parser<bool> _char() => any().except([
      ...["(", ")", "[", "]", "{", "}"],
      ...["(?:", "(?=", "(?!", "(?<=", "(?<!", "[^"],
      ...[",", "|", "*", "+", "?", r"\", r"$"]
    ].trie()).map(($) => false);

Parser<bool> integer() => codeRange("0".unit, "9".unit).plus().flat().map((v) => int.parse(v) > 0);
