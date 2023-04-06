// ignore_for_file: literal_only_boolean_expressions

import "package:parser_combinator/example/asciimath/definitions.dart";
import "package:parser_combinator/parser_combinator.dart";

class _MathTranslator extends PegGrammar<String> with AsciiMathDefinitions {
  const _MathTranslator();

  static Parser<String> untrimmedAsciiMathSymbolsIn(List<AsciiMathConversion> symbol) =>
      symbol.map((r) => r.asciimath).trie();

  static Parser<String> asciiMathSymbolsIn(List<AsciiMathConversion> symbol) =>
      symbol.map((r) => r.asciimath).trie().trim();

  @override
  Parser<String> root() => document.$();

  // Document
  Parser<String> document() => line
      .reference() //
      .prefix(samedent().trim())
      .separated(newline())
      .map(($) => $.join(r"\\" "\n"));

  Parser<String> line() => expression.$().trim().plus().map(($) => $.join(" "));

  Parser<String> block() => document.$().surrounded(newline() + indent(), dedent());

  Parser<String> expression() => [
        environment.$(), //
        combined.$(),
      ].choice();

  Parser<String> combined() => [
        fraction.$(), //
        post.$(),
      ].choice();

  Parser<String> post() => [
        script.$(), //
        operator.$(),
      ].choice();

  Parser<String> operator() => [
        binary.$(), //
        unary.$(),
        atomic.$(),
      ].choice();

  Parser<String> atomic() => [
        matrix.$(),
        group.$(),
        number.$(),
        text.$(),
        escaped.$(),
        symbol.$(),
        greekLetter.$(),
        identifier.$(),
        unknown.$(),
      ].choice();

  Parser<String> environment() => ("#".tok(), identifier.$(), environmentArgs.$(), block.$()) //
      .sequence()
      .map(($) => switch ($) {
            (_, String name, String args, String body) => "\\begin{$name}$args\n${body.indent()}\n\\end{$name}\n",
          });

  Parser<String> environmentArgs() => environmentArg.$().star().map(($) => $.join());
  Parser<String> environmentArg() => (untrimmedLeft.$(), document.$(), untrimmedRight.$()) //
      .sequence()
      .map(($) => switch ($) {
            (String l, String value, String r) => "$l$value$r",
          });

  Parser<String> fraction() => (post.$(), "/".tok().except("//".tok()), post.$()) //
      .sequence()
      .map(($) => switch ($) {
            (String numerator, _, String denominator) => "\\frac{${unwrap(numerator)}}{${unwrap(denominator)}}",
          });

  Parser<String> script() => (operator.$(), (scriptOp.$(), operator.$()).sequence().star()).sequence().map(($) {
        var (String left, List<(String, String)> scripts) = $;
        StringBuffer buffer = StringBuffer()..write(left);
        for (var (String op, String right) in scripts) {
          buffer
            ..write(op)
            ..write("{${unwrap(right)}}");
        }

        return buffer.toString();
      });

  Parser<String> matrix() => (leftBracket.$() + matrixContent.$() + rightBracket.$()).map(($) {
        var [left as String, body as String, right as String] = $;

        return "$left\\begin{matrix}\n${body.indent()}\n\\end{matrix}$right";
      });
  Parser<String> matrixContent() => (matrixRow.$() % ",".tokNl()).map(($) {
        return $.join(r"\\" "\n");
      });
  Parser<String> matrixRow() => (matrixMembers.$() % ",".tok()).surrounded(leftBracket.$(), rightBracket.$()).map(($) {
        return $.join(" & ");
      });
  Parser<String> matrixMembers() => matrixMember.$().plus().map(($) {
        return $.join(" ");
      });
  Parser<String> matrixMember() => expression.$().except(",".tok() / rightBracket.$()).trim().map(($) {
        if ($ == "|") {
          return r"\bigm|";
        }
        return $;
      });

  Parser<String> group() => (leftBracket.$(), groupBody.$(), rightBracket.$()).sequence().map(($) {
        var (String left, String body, String right) = $;

        return "$left$body$right";
      });
  Parser<String> groupBody() => expression.$().except(rightBracket.$()).trimNewline().star().map(($) {
        return $.join(" ");
      });

  Parser<String> binary() => (binaryOperator.$() + operator.$().trimRight() + operator.$()).map(($) {
        var [conversion as AsciiMathConversion, left as String, right as String] = $;
        String op = conversion.tex ?? conversion.asciimath;
        var (String unwrappedLeft, String unwrappedRight) = (unwrap(left), unwrap(right));

        if (conversion.firstIsOption) {
          return "$op[$unwrappedLeft]{$unwrappedRight}";
        } else {
          return "$op{$unwrappedLeft}{$unwrappedRight}";
        }
      });
  Parser<String> unary() => (unaryOperator.$(), atomic.$()).sequence().map(($) {
        var (AsciiMathConversion conversion, String value) = $;
        String op = conversion.tex ?? conversion.asciimath;
        String unwrapped = unwrap(value);

        return switch (conversion.rewriteLeftRight) {
          (String left, String right) => "$left $unwrapped $right",
          null => "$op{$unwrapped}",
        };
      });

  Parser<String> greekLetter() => asciiMathSymbolsIn(greekLetters).map((k) => symbolMap[k]?.tex ?? k);
  Parser<AsciiMathConversion> binaryOperator() => asciiMathSymbolsIn(binarySymbols).map((k) => symbolMap[k]!);
  Parser<AsciiMathConversion> unaryOperator() => asciiMathSymbolsIn(unarySymbols).map((k) => symbolMap[k]!);

  Parser<String> leftBracket() => asciiMathSymbolsIn(leftBracketSymbols) //
      .map((k) => "\\left${symbolMap[k]?.tex ?? k}");
  Parser<String> rightBracket() => asciiMathSymbolsIn(rightBracketSymbols) //
      .map((k) => "\\right${symbolMap[k]?.tex ?? k}");

  Parser<String> untrimmedLeft() =>
      untrimmedAsciiMathSymbolsIn(leftBracketSymbols).map((k) => "\\left${symbolMap[k]?.tex ?? k}");
  Parser<String> untrimmedRight() =>
      untrimmedAsciiMathSymbolsIn(rightBracketSymbols).map((k) => "\\right${symbolMap[k]?.tex ?? k}");

  Parser<String> symbol() => asciiMathSymbolsIn(aloneSymbol).except(group.$()).map((k) => symbolMap[k]?.tex ?? "\\$k");

  Parser<String> escaped() => any().prefix(r"\".p()).flat();
  Parser<String> unknown() => any().except(notUnknown.$()).flat();
  Parser<String> notUnknown() => [",".p(), " ".p(), ":".p(), newline().flat()].firstChoice();
  Parser<String> scriptOp() => r"[\^_]".r().except(symbol.$());

  Parser<String> identifier() => r"[A-Za-zΑ-Ωα-ω\$][A-Za-z0-9Α-Ωα-ω\$\-\*\+]*".r();
  Parser<String> number() => r"(?:\d*\.\d+)|(?:\d+)".r();
  Parser<String> text() => regex(r'(?:(?:\\.)|(?:[^"]))*') //
      .surrounded('"'.p(), '"'.p())
      .map((v) => "\\text{$v}");

  // Parsers used in post.
  Parser<String> _unwrap() => _sustain
      .reference() //
      .surrounded(r"\left".s() + leftBracket.$(), r"\right".s() + rightBracket.$());

  Parser<String> _sustain() => _sustainMember.$().plus().flat();
  Parser<Object> _sustainMember() =>
      leftBracket.$() & _sustain.$() & rightBracket.$() | //
      any().except(r"\right".s() & rightBracket.$());

  String unwrap(String target) => switch (_unwrap.peg.primitive(target).tryUnwrap()) {
        String result => result,
        null => target,
      };
}

const _MathTranslator _instance = _MathTranslator();

String asciiMathToTex(String input) => _instance.run(input).unwrap();

extension on String {
  String indent() => split("\n").map((v) => "  $v").join("\n");
}
