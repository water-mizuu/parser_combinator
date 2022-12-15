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
  PreUnaryExpression.fromList(List<Object> list)
      : operator = list[0] as String,
        value = list[1] as MathExpression;

  @override
  num evaluate() {
    switch (operator) {
      case "-":
        return -value.evaluate();
      default:
        throw StateError("Unknown operator '$value'");
    }
  }

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
  BinaryExpression.fromList(List<Object> $)
      : left = $[0] as MathExpression,
        operator = $[1] as String,
        right = $[2] as MathExpression;

  @override
  num evaluate() {
    switch (operator) {
      case "+":
        return left.evaluate() + right.evaluate();
      case "-":
        return left.evaluate() - right.evaluate();
      case "*":
        return left.evaluate() * right.evaluate();
      case "/":
        return left.evaluate() / right.evaluate();
      case "~/":
        return left.evaluate() ~/ right.evaluate();
      case "^":
      case "**":
        return math.pow(left.evaluate(), right.evaluate());
      default:
        throw StateError("Unknown operator '$operator'");
    }
  }

  @override
  String get infixNotation {
    String left = this.left.infixNotation;
    String right = this.right.infixNotation;
    String leftFormatted = left.contains(" ") ? "($left)" : left;
    String rightFormatted = right.contains(" ") ? "($right)" : right;

    return "$leftFormatted $operator $rightFormatted";
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
