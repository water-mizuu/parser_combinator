import "package:parser_combinator/parser_combinator.dart";

typedef PV = Parser<Object?>;

/// An example parser combinator setup that parses JSON text without
///   converting them into proper Map/List/Objects.
Parser<Object?> jsonParser() => _jsonParser.build();

PV _mapParser() => (_stringParser.r$ & string(":").tnl() & _jsonParser.r$)
    .separated(string(",").tnl())
    .surrounded(string("{").tnl(), string("}").tnl());

PV _stringParser() =>
    regex(r"""(?:")((?:(?:(?=\\)\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4}))|[^"\\\0-\x1F\x7F]+)*)(?:")""").tnl();

PV _numberParser() => regex(r"-?[0-9]+(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?").tnl();

PV _arrayParser() => _jsonParser.r$ //
    .separated(string(",").tnl())
    .surrounded(string("[").tnl(), string("]").tnl());

PV _jsonParser() =>
    _mapParser.r$ | //
    _arrayParser.r$ |
    _numberParser.r$ |
    _stringParser.r$ |
    string("true") |
    string("false") |
    string("null")
    //
    ;
