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

final Parser<String> binaryOperators = trie(<String>["^", "**", "*", "/", "%", "~/", "-", "+"]).trim(layout, layout);
final Parser<String> unaryOperators = trie(<String>["!", "-", "sqrt"]).trim(layout, layout);

/// A parser that purposely uses ambiguity. <br>
/// This only properly works with gll parsing.
/// The definition of the grammar is:
/// ```dart
/// E = binary-op E E {
///       switch ($1) {
///         "+" => $2 + $3,
///         "-" => $2 - $3,
///         "*" => $2 * $3,
///         "%" => $2 % $3,
///         "/" => $2 / $3,
///         "~/" => $2 ~/ $3,
///         "^" || "**" => $2 ^ $3,
///         var v => throw "Unknown operator $v",
///       }
///     }
///   | unary-op E {
///       switch ($1) {
///         "sqrt" => sqrt($2),
///         "-" => -$2,
///         "!" => Π($2),
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
    (binaryOperators, pnParser.$(), pnParser.$()).sequence().map(((String, num, num) $) => //
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
    (unaryOperators, pnParser.$()).sequence().map(((String, num) $) => //
        switch ($) {
          ("sqrt", num v) => sqrt(v),
          ("-", num v) => -v,
          ("!", num v) => piFunction(v),
          (String o, _) => throw Exception("Unknown operator '$o'"),
        }) / //
    pnParser.$().between("(".tok(), ")".tok()) /
    regex(r"\d+").trim().map(num.parse);
