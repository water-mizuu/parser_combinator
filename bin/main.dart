import "dart:io";
import "package:parser_combinator/example.dart";
import "package:parser_combinator/parser_combinator.dart";

void main() {
  stdout.writeln(asciiMathToTex("frac(3 + 2)(4_512) 3/(2 + 3x)"));
  stdout.writeln(asciiMathToTex("sqrt(3_(500))"));
  print(regex("(?:abc)*").isNullable);
}
