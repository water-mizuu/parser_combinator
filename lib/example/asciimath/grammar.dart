import "package:parser_combinator/example/asciimath/definitions.dart";
import "package:parser_combinator/parser_combinator.dart";

class MathTranslator extends PegGrammar<String> with AsciiMathDefinitions {
  static Parser<String> untrimmedAsciiMathSymbolsIn(List<AsciiMathConversion> symbol) =>
      symbol.map((r) => r.asciimath).trie();

  static Parser<String> asciiMathSymbolsIn(List<AsciiMathConversion> symbol) =>
      symbol.map((r) => r.asciimath).trie().trim();

  final bool withCloze;
  MathTranslator({this.withCloze = false});

  @override
  Parser<String> root() => document.$();

  // Document
  Parser<String> document() => (line.$())//
      .prefix(samedent().trim())
      .separated(newline())
      .map(($) => $.join(r"\\" "\n"));

  Parser<String> line() => expression.$()
      .trim()
      .plus()
      .map(($) => $.join(" "));

  Parser<String> block() => document.$()
      .surrounded(newline() + indent(), dedent());

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
        if (withCloze) clozeExpression.$(),
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

  Parser<String> environment() => ("#".tok(), identifier.$(), environmentArgs.$(), block.$()).sequence().map(($) {
    String name = $.$1;
    String args = $.$2;
    String body = $.$3.indent();

    return "\\begin{$name}$args\n$body\n\\end{$name}\n";
  });
  Parser<String> environmentArgs() => environmentArg.$().star().map(($) {
    return $.join();
  });
  Parser<String> environmentArg() => (untrimmedLeft.$(), document.$(), untrimmedRight.$()).sequence().map(($) {
    String left = $.$0;
    String value = $.$1;
    String right = $.$2;

    return "$left$value$right";
  });

  Parser<String> fraction() => (post.$(), "/".tok().except("//".tok()), post.$()).sequence().map(($) {
    String numerator = unwrap($.$0);
    String denominator = unwrap($.$2);

    return "\\frac{$numerator}{$denominator}";
  });
  Parser<String> script() => (operator.$(), (scriptOp.$(), operator.$()).sequence().star()).sequence().map(($) {
    String base = $.$0;
    String scripts = [for ((String, String) pair in $.$1) "${pair.$0}{${unwrap(pair.$1)}}"].join();

    return "$base$scripts";
  });

  Parser<String> clozeExpression() => ("[[".s(), clozeSegments.$(), "]]".s()).sequence().map(($) => "[[${$.$1}]]");
  Parser<String> clozeSegments() => clozeSegment.$().separated("::".s()).map(($) => $.join("::"));
  Parser<String> clozeSegment() => expression.$().except("::".s() / "]]".s()).trim().plus().map(($) => $.join());

  Parser<String> matrix() => (leftBracket.$(), matrixContent.$(), rightBracket.$()).sequence().map(($) {
    String left = $.$0;
    String body = $.$1.indent();
    String right = $.$2;

    return "$left\\begin{matrix}\n$body\n\\end{matrix}$right";
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
    String left = $.$0;
    String body = $.$1;
    String right = $.$2;

    return "$left$body$right";
  });
  Parser<String> groupBody() => expression.$().except(rightBracket.$()).trimNewline().star().map(($) {
    return $.join(" ");
  });

  Parser<String> binary() => (binaryOperator.$(), operator.$().trimRight(), operator.$()).sequence().map(($) {
    AsciiMathConversion conversion = $.$0;
    String op = conversion.tex ?? conversion.asciimath;
    String left = unwrap($.$1);
    String right = unwrap($.$2);

    if (conversion.firstIsOption) {
      return "$op[$left]{$right}";
    } else {
      return "$op{$left}{$right}";
    }
  });
  Parser<String> unary() => (unaryOperator.$(), atomic.$()).sequence().map(($) {
    AsciiMathConversion conversion = $.$0;
    String op = conversion.tex ?? conversion.asciimath;
    String value = unwrap($.$1);

    (String, String)? leftRight = conversion.rewriteLeftRight;
    if (leftRight != null) {
      String left = leftRight.$0;
      String right = leftRight.$1;

      return "$left $value $right";
    } else {
      return "$op{$value}";
    }
  });

  Parser<String> greekLetter() => asciiMathSymbolsIn(greekLetters).map((k) => symbolMap[k]?.tex ?? k);
  Parser<AsciiMathConversion> binaryOperator() => asciiMathSymbolsIn(binarySymbols).map((k) => symbolMap[k]!);
  Parser<AsciiMathConversion> unaryOperator() => asciiMathSymbolsIn(unarySymbols).map((k) => symbolMap[k]!);

  Parser<String> leftBracket() => asciiMathSymbolsIn(leftBracketSymbols) //
      .map((k) => "\\left${symbolMap[k]?.tex ?? k}");
  Parser<String> rightBracket() => asciiMathSymbolsIn(rightBracketSymbols) //
      .map((k) => "\\right${symbolMap[k]?.tex ?? k}");

  Parser<String> untrimmedLeft() => untrimmedAsciiMathSymbolsIn(leftBracketSymbols)
      .map((k) => "\\left${symbolMap[k]?.tex ?? k}");
  Parser<String> untrimmedRight() => untrimmedAsciiMathSymbolsIn(rightBracketSymbols)
      .map((k) => "\\right${symbolMap[k]?.tex ?? k}");

  Parser<String> symbol() => asciiMathSymbolsIn(aloneSymbol).except(group.$())
      .map((k) => symbolMap[k]?.tex ?? "\\$k");

  Parser<String> escaped() => any().prefix(r"\".p()).flat();
  Parser<String> unknown() => any().except(notUnknown.$()).flat();
  Parser<String> notUnknown() => [",".p(), " ".p(), ":".p(), newline().flat()].firstChoice();
  Parser<String> scriptOp() => r"[\^_]".r().except(symbol.$());

  Parser<String> identifier() => r"[A-Za-zΑ-Ωα-ω\$][A-Za-z0-9Α-Ωα-ω\$\-\*\+]*".r();
  Parser<String> number() => r"(?:\d*\.\d+)|(?:\d+)".r();
  Parser<String> text() => r'(?:(?:\\.)|(?:[^"]))*'.r().surrounded('"'.p(), '"'.p()).map((v) => "\\text{$v}");

  // Parsers used in post.
  Parser<String> _unwrap() =>
      (_sustain.$())
        .surrounded(r"\left".s() + leftBracket.$(), r"\right".s() + rightBracket.$())
        .prefix(r"\left".s().and());

  Parser<String> _sustain() => _sustainMember.$().plus().flat();
  Parser<Object> _sustainMember() =>
      leftBracket.$() & _sustain.$() & rightBracket.$() |
      any().except(r"\right".s() & rightBracket.$());

  String unwrap(String target) {
    if (_unwrap.peg(target, handler: PrimitiveHandler()).tryUnwrap() case String result) {
      return result;
    }
    return target;
  }
}

extension on String {
  String indent() => split("\n").map((v) => "  $v").join("\n");
}
