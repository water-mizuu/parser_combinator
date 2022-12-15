import "package:parser_combinator/example/asciimath/grammar.dart";
import "package:parser_combinator/example/reversed_polish_notation/reversed_polish_notation.dart";
import "package:parser_combinator/parser_combinator.dart";

void main() {
  Parser<num> number = rpnParser();
  String input = "124 354 + (378 -) -";

  for (Context<num> result in number.gll(input)) {
    if (result.tryUnwrap() case num value) {
      print("It succeeded!\n$value");
    }
  }

  print(MathTranslator().run("frac(3 + 2)(4_512) 3/(2 + 3x)"));
}
