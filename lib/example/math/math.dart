import "dart:math" as math;

import "package:parser_combinator/parser_combinator.dart";

abstract class MathExpression {
  const MathExpression();
  factory MathExpression.constant(num value) = ConstantExpression;
  factory MathExpression.preUnary(List<Object> list) = PreUnaryExpression.fromList;
  factory MathExpression.binary(List<Object> list) = BinaryExpression.fromList;

  num evaluate();

  String get infixNotation;
  String get postfixNotation;
  String get prefixNotation;
}

class ConstantExpression implements MathExpression {
  final num value;

  const ConstantExpression(this.value);

  @override
  num evaluate() => value;

  @override
  String get infixNotation => "$value";

  @override
  String get postfixNotation => "$value";

  @override
  String get prefixNotation => "$value";
}

class PreUnaryExpression implements MathExpression {
  final String operator;
  final MathExpression value;

  const PreUnaryExpression(this.operator, this.value);
  PreUnaryExpression.fromList(List<Object> objects)
      : operator = objects[0] as String,
        value = objects[1] as MathExpression;

  @override
  num evaluate() => switch ((operator, value.evaluate())) {
        ("-", num value) => -value,
        (String op, _) => throw StateError("Unknown operator '$op'")
      };

  @override
  String get infixNotation => "$operator${value.infixNotation}";

  @override
  String get postfixNotation => "${value.postfixNotation} $operator";

  @override
  String get prefixNotation => "$operator ${value.postfixNotation}";
}

class BinaryExpression extends MathExpression {
  final MathExpression left;
  final String operator;
  final MathExpression right;

  const BinaryExpression(this.left, this.operator, this.right);
  BinaryExpression.fromList(List<Object> objects)
      : left = objects[0] as MathExpression,
        operator = objects[1] as String,
        right = objects[2] as MathExpression;

  @override
  num evaluate() => switch ((left.evaluate(), operator, right.evaluate())) {
        (num left, "+", num right) => left + right,
        (num left, "-", num right) => left - right,
        (num left, "*", num right) => left * right,
        (num left, "/", num right) => left / right,
        (num left, "~/", num right) => left ~/ right,
        (num left, "^" || "**", num right) => math.pow(left, right),
        (_, String op, _) => throw Exception("Unknown operator '$op'"),
      };

  @override
  String get infixNotation {
    String left = switch (this.left.infixNotation) {
      String l when l.contains(" ") => "($l)",
      String l => l,
    };
    String right = switch (this.right.infixNotation) {
      String r when r.contains(" ") => "($r)",
      String r => r,
    };

    return "$left $operator $right";
  }

  @override
  String get postfixNotation => "${left.postfixNotation} ${right.postfixNotation} $operator";

  @override
  String get prefixNotation => "$operator ${left.prefixNotation} ${right.prefixNotation}";
}

Parser<MathExpression> mathParser() => addition.build();
Parser<MathExpression> addition() =>
    (addition.$() + token("+") + multiplication.$()).map(MathExpression.binary) /
    (addition.$() + token("-") + multiplication.$()).map(MathExpression.binary) /
    multiplication.$();

Parser<MathExpression> multiplication() =>
    (multiplication.$() + token("*") + negative.$()).map(MathExpression.binary) /
    (multiplication.$() + token("/") + negative.$()).map(MathExpression.binary) /
    (multiplication.$() + token("~/") + negative.$()).map(MathExpression.binary) /
    negative.$();

Parser<MathExpression> negative() =>
    (token("-") + exponentation.$()).map(MathExpression.preUnary) / //
    exponentation.$();

Parser<MathExpression> exponentation() =>
    (atomic.$() + token("^") + exponentation.$()).map(MathExpression.binary) /
    (atomic.$() + token("**") + exponentation.$()).map(MathExpression.binary) /
    atomic.$();

Parser<MathExpression> atomic() =>
    addition.$().surrounded(token("("), token(")")) / //
    regex(r"\d+").map(num.parse).map(ConstantExpression.new);
