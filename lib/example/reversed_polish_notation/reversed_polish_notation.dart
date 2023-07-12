import "dart:math";

import "package:parser_combinator/example/math/math.dart";
import "package:parser_combinator/parser_combinator.dart";

const int N = 10000;
num piFunction(num x) {
  num product = pow(N + x / 2, x - 1);
  for (int k = 1; k < N; ++k) {
    product *= (k + 1) / (x + k);
  }

  return double.parse(product.toStringAsFixed(3));
}

final Parser<String> binaryOperators = <String>["^", "**", "*", "/", "%", "~/", "-", "+"].trie().trim(layout, layout);
final Parser<String> unaryOperators = <String>["!", "-", "sqrt"].trie().trim(layout, layout);

/// A parser that purposely uses ambiguity. <br>
/// This only properly works with gll parsing.
/// The definition of the grammar is:
/// ```dart
/// E = E E binary-op {
///       switch ($3) {
///         "+" => $1 + $2,
///         "-" => $1 - $2,
///         "*" => $1 * $2,
///         "%" => $1 % $2,
///         "/" => $1 / $2,
///         "~/" => $1 ~/ $2,
///         "^" || "**" => $1 ^ $2,
///         var v => throw "Unknown operator $v",
///       }
///     }
///   | E unary-op {
///       switch ($2) {
///         "sqrt" => sqrt($1),
///         "-" => -$0,
///         "!" => Π($1),
///         var v => throw "Unknown operator $v",
///       }
///     }
///   | atom
///
/// binary-op = "^" | "**" | "*" | "/" | "%" | "~/" | "-" | "+"
/// unary-op = "!" | "-" | "sqrt"
/// atom = /\d+/
/// ```
Parser<num> rpnParser() =>
    binaryOperation ^ rpnParser.$() & rpnParser.$() & binaryOperators | //
    unaryOperation ^ rpnParser.$() & unaryOperators | //
    surround ^ "(".tok() & rpnParser.$() & ")".tok() |
    num.parse ^ regex(r"\d+").trim();

num binaryOperation(List<Object?> $) => //
    switch ($) {
      [num l, num r, "+"] => l + r,
      [num l, num r, "-"] => l - r,
      [num l, num r, "*"] => l * r,
      [num l, num r, "/"] => l / r,
      [num l, num r, "~/"] => l ~/ r,
      [num l, num r, "%"] => l % r,
      [num l, num r, "^" || "**"] => pow(l, r),
      [_, _, String o] => throw Exception("Unknown operator '$o'"),
      _ => throw Exception("Unknown value ${$}"),
    };
num unaryOperation(List<Object?> $) => //
    switch ($) {
      [num v, "sqrt"] => sqrt(v),
      [num v, "-"] => -v,
      [num v, "!"] => piFunction(v),
      [_, String o] => throw Exception("Unknown operator '$o'"),
      _ => throw Exception("Unknown value ${$}"),
    };
num surround(List<Object?> v) => v[1]! as num;
