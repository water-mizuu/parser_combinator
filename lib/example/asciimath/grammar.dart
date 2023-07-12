// ignore_for_file: literal_only_boolean_expressions

import "package:parser_combinator/parser_combinator.dart";

part "definitions.dart";

class _MathTranslator extends PegGrammar<String> with _AsciiMathDefinitions {
  const _MathTranslator();

  static Parser<String> untrimmedAsciiMathSymbolsIn(List<_AsciiMathConversion> symbol) =>
      symbol.map((_AsciiMathConversion r) => r.asciimath).trie();

  static Parser<String> asciiMathSymbolsIn(List<_AsciiMathConversion> symbol) =>
      symbol.map((_AsciiMathConversion r) => r.asciimath).trie().trim();

  @override
  Parser<String> root() => document.ref;

  // Document
  Parser<String> document() => line.ref //
      .prefix(samedent().trim())
      .separated(newline())
      .map((List<String> $) => $.join(r"\\" "\n"));

  Parser<String> line() => expression.ref.trim().plus().map((List<String> $) => $.join(" "));

  Parser<String> block() => document.ref.surrounded(newline() + indent(), dedent());

  Parser<String> expression() => environment.ref | combined.ref;

  Parser<String> combined() => fraction.ref | post.ref;

  Parser<String> post() => script.ref | operator.ref;

  Parser<String> operator() => binary.ref | unary.ref | atomic.ref;

  Parser<String> atomic() =>
      matrix.ref |
      group.ref |
      number.ref |
      text.ref |
      escaped.ref |
      symbol.ref |
      greekLetter.ref |
      identifier.ref |
      unknown.ref;

  Parser<String> environment() => ("#".tok(), identifier.ref, environmentArgs.ref, block.ref) //
      .sequence()
      .map(((void, String, String, String) $) => switch ($) {
            (_, String name, String args, String body) => "\\begin{$name}$args\n${body.indent()}\n\\end{$name}\n",
          });

  Parser<String> environmentArgs() => environmentArg.ref.star().map((List<String> $) => $.join());
  Parser<String> environmentArg() => (untrimmedLeft.ref, document.ref, untrimmedRight.ref) //
      .sequence()
      .map(((String, String, String) $) => switch ($) {
            (String l, String value, String r) => "$l$value$r",
          });

  Parser<String> fraction() => (post.ref, "/".tok().except("//".tok()), post.ref) //
      .sequence()
      .map(((String, String, String) $) => switch ($) {
            (String numerator, _, String denominator) => r"\frac" "{${unwrap(numerator)}}{${unwrap(denominator)}}",
          });

  Parser<String> script() => (operator.ref, (scriptOp.ref, operator.ref).sequence().star())
          .sequence()
          .map(((String, List<(String, String)>) $) {
        var (String left, List<(String, String)> scripts) = $;
        StringBuffer buffer = StringBuffer()..write(left);
        for (var (String op, String right) in scripts) {
          buffer
            ..write(op)
            ..write("{${unwrap(right)}}");
        }

        return buffer.toString();
      });

  Parser<String> matrix() => (leftBracket.ref, matrixContent.ref, rightBracket.ref) //
          .sequence()
          .map(((String, String, String) $) {
        var (String left, String body, String right) = $;

        return "$left\\begin{matrix}\n${body.indent()}\n\\end{matrix}$right";
      });
  Parser<String> matrixContent() => (matrixRow.ref % ",".tokNl()).map((List<String> $) => $.join(r"\\" "\n"));
  Parser<String> matrixRow() => (matrixMembers.ref % ",".tok()) //
      .surrounded(leftBracket.ref, rightBracket.ref)
      .map((List<String> $) => $.join(" & "));

  Parser<String> matrixMembers() => matrixMember.ref //
      .plus()
      .map((List<String> $) => $.join(" "));

  Parser<String> matrixMember() => expression.ref //
      .except(",".tok() | rightBracket.ref)
      .trim()
      .map((String $) => switch ($) {
            "|" => r"\bigm|",
            _ => $,
          });

  Parser<String> group() =>
      (leftBracket.ref, groupBody.ref, rightBracket.ref).sequence().map(((String, String, String) $) {
        var (String left, String body, String right) = $;

        return "$left$body$right";
      });
  Parser<String> groupBody() => expression.ref //
      .except(rightBracket.ref)
      .trimNewline()
      .star()
      .map((List<String> $) => $.join(" "));

  Parser<String> binary() => (binaryOperator.ref, operator.ref.trimRight(), operator.ref) //
          .sequence()
          .map(((_AsciiMathConversion, String, String) $) {
        var (_AsciiMathConversion conversion, String left, String right) = $;
        String op = conversion.tex ?? conversion.asciimath;
        var (String unwrappedLeft, String unwrappedRight) = (unwrap(left), unwrap(right));

        if (conversion.firstIsOption) {
          return "$op[$unwrappedLeft]{$unwrappedRight}";
        } else {
          return "$op{$unwrappedLeft}{$unwrappedRight}";
        }
      });
  Parser<String> unary() => (unaryOperator.ref, atomic.ref).sequence().map(((_AsciiMathConversion, String) $) {
        var (_AsciiMathConversion conversion, String value) = $;
        var (String op, String unwrapped) = (conversion.tex ?? conversion.asciimath, unwrap(value));

        return switch (conversion.rewriteLeftRight) {
          (String left, String right) => "$left $unwrapped $right",
          null => "$op{$unwrapped}",
        };
      });

  Parser<String> greekLetter() => asciiMathSymbolsIn(greekLetters).map((String k) => symbolMap[k]?.tex ?? k);
  Parser<_AsciiMathConversion> binaryOperator() => asciiMathSymbolsIn(binarySymbols).map((String k) => symbolMap[k]!);
  Parser<_AsciiMathConversion> unaryOperator() => asciiMathSymbolsIn(unarySymbols).map((String k) => symbolMap[k]!);

  Parser<String> leftBracket() => asciiMathSymbolsIn(leftBracketSymbols) //
      .map((String k) => "\\left${symbolMap[k]?.tex ?? k}");
  Parser<String> rightBracket() => asciiMathSymbolsIn(rightBracketSymbols) //
      .map((String k) => "\\right${symbolMap[k]?.tex ?? k}");

  Parser<String> untrimmedLeft() =>
      untrimmedAsciiMathSymbolsIn(leftBracketSymbols).map((String k) => "\\left${symbolMap[k]?.tex ?? k}");
  Parser<String> untrimmedRight() =>
      untrimmedAsciiMathSymbolsIn(rightBracketSymbols).map((String k) => "\\right${symbolMap[k]?.tex ?? k}");

  Parser<String> symbol() =>
      asciiMathSymbolsIn(aloneSymbol).except(group.ref).map((String k) => symbolMap[k]?.tex ?? "\\$k");

  Parser<String> escaped() => any().prefix(r"\".p()).flat();
  Parser<String> unknown() => any().except(notUnknown.ref).flat();
  Parser<String> notUnknown() => <Parser<String>>[",".p(), " ".p(), ":".p(), newline().flat()].firstChoice();
  Parser<String> scriptOp() => r"[\^_]".r().except(symbol.ref);

  Parser<String> identifier() => r"[A-Za-zΑ-Ωα-ω\$][A-Za-z0-9Α-Ωα-ω\$\-\*\+]*".r();
  Parser<String> number() => r"(?:\d*\.\d+)|(?:\d+)".r();
  Parser<String> text() => regex(r'(?:(?:\\.)|(?:[^"]))*') //
      .surrounded('"'.p(), '"'.p())
      .map((String v) => "\\text{$v}");

  // Parsers used in post.
  Parser<String> _unwrap() => _sustain
      .reference() //
      .surrounded(r"\left".s() + leftBracket.ref, r"\right".s() + rightBracket.ref);

  Parser<String> _sustain() => _sustainMember.ref.plus().flat();
  Parser<Object> _sustainMember() =>
      (leftBracket.ref & _sustain.ref & rightBracket.ref) / //
      any().except(r"\right".s() & rightBracket.ref);

  String unwrap(String target) => switch (_unwrap.peg.primitive(target).tryUnwrap()) {
        String result => result,
        null => target,
      };
}

const _MathTranslator _instance = _MathTranslator();

/// Parses an `AsciiMath` expression into equivalent `LaTeX`.
String asciiMathToTex(String input) => _instance.run(input).unwrap();

extension on String {
  String indent() => split("\n").map((String v) => "  $v").join("\n");
}
