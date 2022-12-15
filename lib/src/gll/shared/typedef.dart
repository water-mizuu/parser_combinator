import "dart:collection";

import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/entry.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

typedef Continuation<Out> = void Function(Context<Out>);
typedef MemoizationTable = HashMap<Parser<void>, HashMap<int, HashMap<int, ParserEntry<void>>>>;
