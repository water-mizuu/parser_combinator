import "package:parser_combinator/parser_combinator.dart";

typedef PV = Parser<Object?>;

Parser<Object?> jsonParser() => _jsonParser.build();

PV _mapParser() => (_stringParser.$() & string(":").tnl() & _jsonParser.$())
    .separated(string(",").tnl())
    .surrounded(string("{").tnl(), string("}").tnl());

PV _stringParser() =>
    regex(r"""(?:")((?:(?:(?=\\)\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4}))|[^"\\\0-\x1F\x7F]+)*)(?:")""").tnl();

PV _numberParser() => regex(r"-?[0-9]+(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?").tnl();

PV _arrayParser() => _jsonParser
    .$() //
    .separated(string(",").tnl())
    .surrounded(string("[").tnl(), string("]").tnl());

PV _jsonParser() =>
    _mapParser.$() | //
    _arrayParser.$() |
    _numberParser.$() |
    _stringParser.$() |
    string("true") |
    string("false") |
    string("null")
    //
    ;
