import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/extension/run.dart";
import "package:parser_combinator/src/grammar/abstract/parser_grammar.dart";

///
/// A helper class that indicates the limitation of a grammar to
/// be limited only to `GLL specification`.
///
abstract class GllGrammar<R extends Object?> extends ParserGrammar<R, Iterable<Context<R>>> {
  const GllGrammar();

  @override
  Iterable<Context<R>> run(String input) {
    return built.gll(input, build: false);
  }
}
