// ignore_for_file: avoid_positional_boolean_parameters

import "package:meta/meta.dart";

part "empty.dart";
part "failure.dart";
part "success.dart";

///
/// Parse context used in parsing the text.
///
@immutable
sealed class Context<R> {
  ///
  /// The input buffer being parsed.
  ///
  final String input;

  ///
  /// The current index in the parsing context.
  ///
  final int index;

  ///
  /// The indentation stack.
  ///
  final List<int> indentation;

  const Context(this.input, this.index, this.indentation);

  const factory Context.success(R value, [Object? cst, String input, int index]) = Success;
  const factory Context.failure(String message, [String input, int index]) = Failure;
  const factory Context.empty([Object? cst, String input, int index]) = Empty;

  ///
  /// Replaces the int [index] of a [Context] object.
  ///
  Context<R> replaceIndex(int index);

  ///
  /// Replaces the String [input] of a [Context] object.
  ///
  Context<R> replaceInput(String input);

  ///
  /// Returns a new [Context] that takes from the given [context],
  ///   although keeping its generic type.
  ///
  Context<R> inherit<I>(Context<I> context);

  ///
  /// Returns a new [Context] object with one indent value added.
  ///
  Context<R> pushIndent(int indent);

  ///
  /// Returns a new [Context] object with one indent value removed.
  ///
  Context<R> popIndent();

  ///
  /// Replaces a context with a [Success], taking
  ///   a required [result],
  ///   an optional [cst] and [index].
  ///
  @pragma("vm:prefer-inline")
  Success<O> success<O>(O result, [Object? cst, int? index]) => //
      Success<O>(result, cst, input, index ?? this.index, indentation);

  ///
  /// Replaces a context with a [Failure], taking
  ///   an optional [message] and [artificial].
  ///
  @pragma("vm:prefer-inline")
  Failure failure([String? message, bool artificial = false]) => //
      (artificial ? Failure.artificial : Failure.new)(message ?? this.message, input, index, indentation);

  ///
  /// Replaces a context with a [Empty], taking
  ///   an optional [cst] and [index].
  ///
  @pragma("vm:prefer-inline")
  Empty empty([Object? cst, int? index]) => //
      Empty(cst, input, index ?? this.index, indentation);

  ///
  /// Casts a [Context] to another generic [Context].
  ///
  @pragma("vm:prefer-inline")
  Context<O> cast<O>() => this as Context<O>;

  ///
  /// The value that is successfully parsed that is returned by a parser.
  ///
  R get value;

  ///
  /// The value that is successfully parsed without any processing.
  ///
  Object? get cst;

  ///
  /// The error message returned from a parsing failure.
  ///
  String get message;

  ///
  /// Returns the [value] if valid, else it throws an [UnsupportedError].
  ///
  R unwrap();

  ///
  /// Just like [unwrap], but returns null instead.
  ///
  R? tryUnwrap();

  static R getValue<R>(Context<R> context) => context.value;
  static String getMessage<R>(Context<R> context) => context.message;
  static Object? getAst<R>(Context<R> context) => context.cst;

  static final RegExp _spaceRegExp = RegExp(r"[ \t]*");
  static final Expando<List<String>> _linesExpando = Expando<List<String>>();
  static final Expando<Map<int, List<String>>> _linesToIndexExpando = Expando<Map<int, List<String>>>();

  List<String> get _lines => _linesExpando[this] ??= "$input ".split("\n");
  List<String> get _linesToIndex => (_linesToIndexExpando[this] ??= <int, List<String>>{}) //
      .putIfAbsent(index, () => "$input ".substring(0, index + 1).split("\n"));

  ///
  /// Counts all the newline tokens up until [index], adding 1.
  ///
  int get line => _linesToIndex.length;

  ///
  /// Gets the current line of [index], then counts all the characters
  /// until the latest newline OR beginning of input.
  ///
  int get column => _linesToIndex.last.length;

  ///
  /// Gets the indentation of the current line from [index].
  ///
  int get indent => _spaceRegExp.matchAsPrefix(_lines[this.line - 1])?.end ?? 0;

  ///
  /// Returns the string representation of the current [line] and [column]
  ///   from the [index] at the format of "[line], [column]"
  ///
  String get location => "$line, $column";
}
