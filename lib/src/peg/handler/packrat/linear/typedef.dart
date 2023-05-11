import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/default_map.dart";

typedef ParsingTable = DefaultExpando<Parser<void>, ParsingSubMap>;
typedef ParsingSubMap = DefaultMap<int, Map<int, Context<void>>>;

ParsingTable createParsingTable() => ParsingTable((_) => ParsingSubMap((_) => <int, Context<void>>{}));
