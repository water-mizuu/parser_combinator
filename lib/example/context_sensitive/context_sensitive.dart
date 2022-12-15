import "package:parser_combinator/parser_combinator.dart";

Parser<void> b(int i) => string("b") * i;
Parser<void> c(int i) => string("c") * i;
Parser<void> bc(int i) => b(i) & c(i);
Parser<void> abc(int i) => string("a") & (bc.$(i) / abc.$(i + 1));

/// A demonstration of parsing an example context-sensitive grammar. <br>
/// Running `.build()` or generating a graph is impossible. <br>
/// The language is defined as:
/// ```
/// S = { a^n b^n c^n | n ∈ ℕ }
/// S = { abc, aabbcc, aaabbbccc, ... }
/// ```
Parser<String> contextSensitiveParser() => abc(1).flat();
