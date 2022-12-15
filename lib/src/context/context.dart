// ignore_for_file: avoid_positional_boolean_parameters

import "package:meta/meta.dart";
import "package:parser_combinator/src/context/empty.dart";
import "package:parser_combinator/src/context/failure.dart";
import "package:parser_combinator/src/context/success.dart";

///
/// Parse context used in parsing the text.
///
@immutable
abstract class Context<R> {
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

  Context<R> replaceIndex(int index);
  Context<R> replaceInput(String input);
  Context<R> inherit<I>(Context<I> context);

  Context<R> pushIndent(int indent);
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

  @pragma("vm:prefer-inline")
  Context<O> cast<O>() => this as Context<O>;

  R get value;
  Object? get cst;
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

  static final RegExp _spaceRegExp = RegExp("[ \t]*");
  static final Expando<List<String>> _linesExpando = Expando();
  static final Expando<Map<int, List<String>>> _linesToIndexExpando = Expando();

  List<String> get _lines => _linesExpando[this] ??= "$input ".split("\n");
  List<String> get _linesToIndex => (_linesToIndexExpando[this] ??= {}) //
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

  String get location => "$line, $column";
}
