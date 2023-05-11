import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

part "call.dart";
part "continue.dart";

///
/// An interface used in the [Trampoline] to execute `GLL` calls.
///
sealed class ParserAction {
  void call(Trampoline trampoline);
}
