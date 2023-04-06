import "dart:math";

import "package:parser_combinator/parser_combinator.dart";

const int N = 10000;
num piFunction(num x) {
  num product = pow(N + x / 2, x - 1);
  for (int k = 1; k < N; ++k) {
    product *= (k + 1) / (x + k);
  }

  return double.parse(product.toStringAsFixed(3));
}

Parser<String> binaryOperators = trie(["^", "**", "*", "/", "%", "~/", "-", "+"]).trim(layout, layout);
Parser<String> unaryOperators = trie(["!", "-", "sqrt"]).trim(layout, layout);

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
Parser<num> pnParser() =>
    (binaryOperators, pnParser.$(), pnParser.$()).sequence().map(($) => //
        switch ($) {
          ("+", num l, num r) => l + r,
          ("-", num l, num r) => l - r,
          ("*", num l, num r) => l * r,
          ("/", num l, num r) => l / r,
          ("~/", num l, num r) => l ~/ r,
          ("%", num l, num r) => l % r,
          ("^" || "**", num l, num r) => pow(l, r),
          (String o, _, _) => throw Exception("Unknown operator '$o'"),
        }) / //
    (unaryOperators, pnParser.$()).sequence().map(($) => //
        switch ($) {
          ("sqrt", num v) => sqrt(v),
          ("-", num v) => -v,
          ("!", num v) => piFunction(v),
          (String o, _) => throw Exception("Unknown operator '$o'"),
        }) / //
    pnParser.$().between("(".tok(), ")".tok()) /
    regex(r"\d+").trim().map(num.parse);
