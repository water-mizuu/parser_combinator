import "package:parser_combinator/src/gll/class/trampoline.dart";

///
/// An interface used in the [Trampoline] to execute `GLL` calls.
///
abstract class ParserAction {
  void call(Trampoline trampoline);
}
