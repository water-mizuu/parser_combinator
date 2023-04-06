import "package:parser_combinator/example.dart";
import "package:parser_combinator/parser_combinator.dart";
import "package:parser_combinator/src/extension/ascii_tree/parser.dart";
import "package:parser_combinator/src/shared/multi_map.dart";

void main() {
  Trie trie = Trie.from(["hello", "hi", "five", "hell"]);

  String something = "iiii";
  print(trie.keys);

  /// h
  ///   e
  ///     l
  ///       l
  ///         .
  ///         o
  ///           .
  ///   i
  ///     .
  /// f
  ///   i
  ///     v
  ///       e

  // Parser<num> number = rpnParser();
  // String input = "124 354 + 378 200 - - +";

  // Context<num> context = number.gll(input).first;
  // print(switch (context) {
  //   Success(:num value) => "$value",
  //   Failure(:String failureMessage) => failureMessage,
  //   Empty _ => "",
  // });

  print(asciiMathToTex("frac(3 + 2)(4_512) 3/(2 + 3x)"));
  print(asciiMathToTex("sqrt(3_(500))"));

  // print(regex("(?:abc)*").isNullable);
}
