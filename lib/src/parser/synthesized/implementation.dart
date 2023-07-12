part of "builtin.dart";

// cspell:disable
// BASIC
Parser<String> _digit() => codeRange("0".unit, "9".unit);
Parser<String> _digits() => _digit().plus().flat();

Parser<String> _lowercase() => codeRange("a".unit, "z".unit);
Parser<String> _uppercase() => codeRange("A".unit, "Z".unit);

Parser<String> _lowercaseGreek() => codeRange("α".unit, "ω".unit);
Parser<String> _uppercaseGreek() => codeRange("Α".unit, "Ω".unit);

Parser<String> _letter() => _lowercase() | _uppercase();
Parser<String> _letters() => _letters().plus().flat();

Parser<String> _greek() => _lowercaseGreek() | _uppercaseGreek();
Parser<String> _greeks() => _greek().plus().flat();

Parser<String> _alphanum() => _digit() | _letter();
Parser<String> _alphaNums() => _alphanum().plus().flat();

Parser<String> _hex() => _digit() | codeRange("a".unit, "f".unit);
Parser<String> _hexes() => _hex().plus().flat();

Parser<String> _octal() => codeRange("0".unit, "7".unit);
Parser<String> _octals() => _octal().plus().flat();

Parser<String> _delimitedStar(Parser<String> delimiter) => //
    (string(r"\") & any() | delimiter.not() & any()).star().flat().surrounded(delimiter, delimiter);
Parser<String> _delimitedSingle(Parser<String> delimiter) => //
    (string(r"\") & any() | delimiter.not() & any()).flat().surrounded(delimiter, delimiter);

// STRING
Parser<String> _string() => _singleString() | _doubleString();
Parser<String> _singleString() => _delimitedStar("'".p()).message("Expected single-string literal");
Parser<String> _doubleString() => _delimitedStar('"'.p()).message("Expected double-string literal");

// CHAR
Parser<String> _char() => _singleChar() | _doubleChar();
Parser<String> _singleChar() => _delimitedSingle("'".p());
Parser<String> _doubleChar() => _delimitedSingle('"'.p());

// NUMBER FORMATS
// Parser<int> _natural() => codeRange("1".unit, "9".unit).map(int.parse);
// Parser<int> _integer() => ("0".s() | _natural() + _digit().star()).flat().map(int.parse);
// Parser<double> _decimal() => (_digit().star() + ".".s() + _digits()).flat().map(double.parse);

// Parser<num> _number() => [_decimal(), _integer()].firstChoice();

// IDENTIFIER
Parser<String> _identifier() => r"[A-Za-zΑ-Ωα-ω_$:][A-Za-zΑ-Ωα-ω0-9_$\-]*".r();
Parser<String> _cIdentifier() => r"[A-Za-z_$:][A-Za-z0-9_$]*".r();

// OPERATOR
Parser<String> _operator() => r"[<>=!\/&^%+\-#*~]+".r();
Parser<String> _binaryMathOp() => r"[+\-*\/%^]|(?:~/)".r();
Parser<String> _preUnaryMathOp() => "√".r();
Parser<String> _postUnaryMathOp() => "!".r();

// JSON NUMBER

Parser<num> __sign() => "-".s().onSuccess(-1).onFailure(1);
Parser<num> __whole() => "[0-9]+".r().map(num.parse);
Parser<num> __fraction() => r"\.[0-9]+".r().map(num.parse).onFailure(0);
Parser<num> __eMark() => "[Ee]".r().onSuccess(1);
Parser<num> __eSign() => "[+-]".r().onSuccess(1).onFailure(-1);
Parser<num> __power() => (__eMark.$(), __eSign.$(), __whole.$())
    .sequence() //
    .map(((num, num, num) v) => pow(10, v.$1 * v.$2 * v.$3))
    .onFailure(1);
Parser<num> __base() => (__whole.$(), __fraction.$())
    .sequence() //
    .map(((num, num) v) => v.$1 + v.$2);
Parser<num> _completeNumber() => (__base.$(), __power.$())
    .sequence() //
    .map(((num, num) v) => v.$1 * v.$2);
Parser<num> _jsonNumber() => (__sign.$(), __base.$(), __power.$())
    .sequence() //
    .map(((num, num, num) v) => v.$1 * v.$2 * v.$3);

Parser<Object> __controlCharBody() =>
    string(r"\") /
    string('"') /
    string("/") /
    string("b") /
    string("f") /
    string("n") /
    string("r") /
    string("t") /
    hex.$().times(4);
Parser<Object> __controlChar() => string(r"\") + __controlCharBody.$();
Parser<Object> __stringAvoid() => __controlChar.$() | string('"');
Parser<Object> __stringChar() => __controlChar.$() | any().prefix(__stringAvoid.$().not());
Parser<List<Object>> _jsonString() => string('"') + __stringChar.$().star() + string('"');

Parser<int> _newline() => regex(r"(?:\n(?:\r)?)+").map((String v) => v.length);

Pattern layout = RegExp(r"(?:[ \t\r])*");
Pattern newlineLayout = RegExp(r"(?:\s)*");
Parser<String> _token(String value) => string(value).trim(layout, layout);
Parser<String> _tokenNewline(String value) => string(value).trim(newlineLayout, newlineLayout);

extension TokenExtension on String {
  Parser<String> tok() => _token(this);
  Parser<String> tokNl() => _tokenNewline(this);
}
