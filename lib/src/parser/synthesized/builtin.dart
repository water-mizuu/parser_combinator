import "dart:math";

import "package:parser_combinator/parser_combinator.dart";

part "implementation.dart";

// STRING
Parser<String> singleString() => _singleString();
Parser<String> doubleString() => _doubleString();
Parser<String> string([String? pattern]) => pattern == null ? _string() : pattern.s();

// CHAR
Parser<String> char([String? pattern]) => _char();
Parser<String> singleChar() => _singleChar();
Parser<String> doubleChar() => _doubleChar();

// BASIC
Parser<String> digit() => _digit();
Parser<String> digits() => _digits();

Parser<String> lowercase() => _lowercase();
Parser<String> uppercase() => _uppercase();

Parser<String> lowercaseGreek() => _lowercaseGreek();
Parser<String> uppercaseGreek() => _uppercaseGreek();

Parser<String> letter() => _letter();
Parser<String> letters() => _letters();

Parser<String> greek() => _greek();
Parser<String> greeks() => _greeks();

Parser<String> alphaNum() => _alphanum();
Parser<String> alphaNums() => _alphaNums();

Parser<String> hex() => _hex();
Parser<String> hexes() => _hexes();

Parser<String> octal() => _octal();
Parser<String> octals() => _octals();

// INTEGER /DECIMAL
// Parser<num> number() => _number();
// Parser<int> integer() => _integer();
// Parser<double> decimal() => _decimal();

// IDENTIFIER
Parser<String> identifier() => _identifier();
Parser<String> cIdentifier() => _cIdentifier();

// OPERATOR
Parser<String> operator() => _operator();
Parser<String> binaryMathOp() => _binaryMathOp();
Parser<String> preUnaryMathOp() => _preUnaryMathOp();
Parser<String> postUnaryMathOp() => _postUnaryMathOp();

// JSON NUMBER
Parser<num> completeNumberSlow() => _completeNumber();
Parser<num> jsonNumberSlow() => _jsonNumber();

// JSON STRING
Parser<Object> jsonString() => _jsonString();

// NEWLINE
Parser<int> newline() => _newline();

// TOKEN
Parser<String> token(String value) => _token(value);
Parser<String> tokenNewline(String value) => _tokenNewline(value);
