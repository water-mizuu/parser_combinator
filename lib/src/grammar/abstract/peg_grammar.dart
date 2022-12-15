import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/extension/run.dart";
import "package:parser_combinator/src/grammar/abstract/parser_grammar.dart";
import "package:parser_combinator/src/peg/handler/handler.dart";

///
/// A helper class that indicates the limitation of a grammar to
/// be limited only to `PEG specification`.
///
abstract class PegGrammar<R extends Object?> extends ParserGrammar<R, Context<R>> {
  const PegGrammar();

  @override
  Context<R> run(String input, {bool end = false, PegHandler? handler}) {
    return built.peg(input, build: false, end: end, handler: handler);
  }
}
