import "package:parser_combinator/example/math/math.dart";
import "package:parser_combinator/parser_combinator.dart";

/// A regular grammar that demonstrates the parsing of indirect left-recursive grammar. <br>
/// The grammar definition is: <br>
/// ```dart
/// A = B "a" | "a" // This is the root rule.
/// B = A "b" | "b"
/// ```
/// A regular version can be written as:
/// ```
/// A = "ab"* "a"
/// B = "ba"* "b"
/// ```
Parser<void> indirectLeftRecursiveParser() => A.build();

Parser<void> A() => cast<Object>() ^ B.$() & "a".s() | "a".s();
Parser<void> B() => cast<Object>() ^ A.$() & "b".s() | "b".s();

O Function(Object?) cast<O>() => (Object? v) => v as O;
