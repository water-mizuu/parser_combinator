import "dart:math";

import "package:parser_combinator/parser_combinator.dart";

const int N = 100000;
num piFunction(num x) {
  num product = pow(N + x / 2, x - 1);
  for (int k = 1; k < N; ++k) {
    product *= (k + 1) / (x + k);
  }

  return double.parse(product.toStringAsFixed(3));
}

Parser<String> binaryOperators = ["^", "**", "*", "/", "%", "~/", "-", "+"].map(token).choice();
Parser<String> unaryOperators = ["!", "-", "sqrt"].map(token).choice();

/// A parser that purposely uses ambiguity. <br>
/// This only properly works with gll parsing.
/// The definition of the grammar is:
/// ```dart
/// E = E E binary-op {
///       switch ($2) {
///         "+": $0 + $1,
///         "-": $0 - $1,
///         "*": $0 * $1,
///         "%": $0 % $1,
///         "/": $0 / $1,
///         "~/": $0 ~/ $1,
///         "^" || "**": $0 ^ $1,
///         var v: throw "Unknown operator $v",
///       }
///     }
///   | E unary-op {
///       switch ($1) {
///         "sqrt": sqrt($0),
///         "-": -$0,
///         "!": Π($0),
///         var v: throw "Unknown operator $v",
///       }
///     }
///   | atom
///
/// binary-op = "^" | "**" | "*" | "/" | "%" | "~/" | "-" | "+"
/// unary-op = "!" | "-" | "sqrt"
/// atom = /\d+/
/// ```
Parser<num> rpnParser() =>
    (rpnParser.$() & rpnParser.$() & binaryOperators).map(($) {
      num left = $[0].cast<num>();
      num right = $[1].cast<num>();
      String operator = $[2].cast<String>();

      switch (operator) {
        case "+":
          return left + right;
        case "-":
          return left - right;
        case "*":
          return left * right;
        case "/":
          return left / right;
        case "~/":
          return left ~/ right;
        case "%":
          return left % right;
        case "^":
        case "**":
          return pow(left, right);
        default:
          throw Exception("Unknown operator '$operator'");
      }
    }) / //
    (rpnParser.$() & unaryOperators).map(($) {
      num expression = $[0].cast();
      String operator = $[1].cast();

      switch (operator) {
        case "sqrt":
          return sqrt(expression);
        case "-":
          return -expression;
        case "!":
          return piFunction(expression);
        default:
          throw Exception("Unknown operator '$operator'");
      }
    }) / //
    ("(".tok(), rpnParser.$(), ")".tok()).sequence().map(($) => $.$1) /
    regex(r"\d+").trim().map(num.parse);
