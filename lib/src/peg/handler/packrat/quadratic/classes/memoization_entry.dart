import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/classes/left_recursion.dart";

class MemoizationEntry {
  Object value;

  MemoizationEntry(this.value) : assert(value is Context<dynamic> || value is LeftRecursion<dynamic>, "Valid types");
}
