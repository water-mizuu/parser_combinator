import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/classes/memoization_entry.dart";
import "package:parser_combinator/src/shared/default_map.dart";

typedef ParsingTable = DefaultExpando<Parser<void>, ParsingSubMap>;
typedef ParsingSubMap = DefaultMap<int, Map<int, MemoizationEntry>>;
