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
    (rpnParser.$(), rpnParser.$(), binaryOperators).sequence().map(((num, num, String) $) => //
        switch ($) {
          (num l, num r, "+") => l + r,
          (num l, num r, "-") => l - r,
          (num l, num r, "*") => l * r,
          (num l, num r, "/") => l / r,
          (num l, num r, "~/") => l ~/ r,
          (num l, num r, "%") => l % r,
          (num l, num r, "^" || "**") => pow(l, r),
          (_, _, String o) => throw Exception("Unknown operator '$o'"),
        }) / //
    (rpnParser.$(), unaryOperators).sequence().map(((num, String) $) => //
        switch ($) {
          (num v, "sqrt") => sqrt(v),
          (num v, "-") => -v,
          (num v, "!") => piFunction(v),
          (_, String o) => throw Exception("Unknown operator '$o'"),
        }) / //
    rpnParser.$().between("(".tok(), ")".tok()) /
    regex(r"\d+").trim().map(num.parse);
