import "package:parser_combinator/src/extension/build.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

///
/// A helper class that allows indicating the limitation of a parser grammar.
///
abstract class ParserGrammar<R extends Object?, Return extends Object?> {
  static final Expando<Parser<void>> _builtParsers = Expando<Parser<void>>();

  const ParserGrammar();

  Parser<R> get built => (_builtParsers[this] ??= root.build()) as Parser<R>;
  Parser<R> root();

  ///
  /// Method that calls the parser according to the grammar.
  ///
  Return run(String input);
}
