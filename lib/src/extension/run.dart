import "dart:math";

import "package:parser_combinator/parser_combinator.dart";

String _tamperWithString(String input) {
  if (input.isEmpty) {
    return input;
  }

  // Remove \r and \t
  String removed = input.trimRight().replaceAll("\r", "").replaceAll("\t", "    ");

  // Remove trailing right space.
  Iterable<String> lines = removed.split("\n").map((line) => line.trimRight());

  // Unindent the string.
  int commonIndentation = lines //
      .where((line) => line.isNotEmpty)
      .map((line) => line.length - line.trimLeft().length)
      .reduce(min);

  Iterable<String> unindented = lines //
      .map((line) => line.isEmpty ? line : line.substring(commonIndentation));

  return unindented.join("\n");
}

Iterable<Context<R>> runParserGll<R>(
  Parser<R> parser,
  String input, {
  bool build = true,
  bool tamper = true,
  bool end = true,
  Trampoline? trampoline,
}) sync* {
  String tampered = tamper ? _tamperWithString(input) : input;

  Trampoline _trampoline = trampoline ?? Trampoline();
  Map<int, List<Failure>> failures = <int, List<Failure>>{};
  List<Success<R>> successes = <Success<R>>[];

  Context<void> context = Context<Never>.empty(null, tampered);
  Parser<R> built = build ? parser.build() : parser; //
  Parser<R> withEnd = end ? built.end() : built;

  _trampoline.add(withEnd, context, (context) {
    if (context case Success<R>()) {
      successes.add(context);
    } else if (context case Failure()) {
      failures.putIfAbsent(context.index, () => []).add(context);
    }
  });

  bool hasYielded = false;
  do {
    while (successes.isEmpty && _trampoline.stack.isNotEmpty) {
      _trampoline.step();
    }

    while (successes.isNotEmpty) {
      yield successes.removeLast();

      hasYielded |= true;
    }
  } while (_trampoline.stack.isNotEmpty);

  if (!hasYielded && failures.isNotEmpty) {
    int max = failures.keys.reduce((a, b) => a > b ? a : b);

    yield* failures[max]!;
  }
}

///
/// Main method that runs a parser grammar in `PEG specification`.
///
Context<R> runParserPeg<R>(
  Parser<R> parser,
  String input, {
  bool build = true,
  bool tamper = true,
  bool end = true,
  PegHandler? handler,
}) {
  String tampered = tamper ? _tamperWithString(input) : input;

  PegHandler _handler = handler ?? QuadraticHandler();
  Context<void> context = Context<Never>.empty(null, tampered);
  Parser<R> built = build ? parser.build() : parser; //
  Parser<R> withEnd = end ? built.end() : built;

  return _handler.parse(withEnd, context);
}

typedef PegRunFn<R> = Context<R> Function(
  String input, {
  bool build,
  bool tamper,
  bool end,
  PegHandler? handler,
});
typedef GllRunFn<R> = Iterable<Context<R>> Function(
  String input, {
  bool build,
  bool tamper,
  bool end,
  Trampoline? trampoline,
});

extension RunParserExtension<R> on Parser<R> {
  ///
  /// Runs a parser grammar using `PEG implementation`.
  /// Faster than GLL, but is more inline with handwritten recursive-descent parsers.
  ///
  Context<R> peg(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    PegHandler? handler,
  }) =>
      runParserPeg(this, input, build: build, tamper: tamper, end: end, handler: handler);

  ///
  /// Runs a parser grammar using `GLL implementation`.
  /// Contains a large overhead, but is able to parse all context-free grammars.
  ///
  Iterable<Context<R>> gll(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    Trampoline? trampoline,
  }) =>
      runParserGll(this, input, build: build, tamper: tamper, end: end, trampoline: trampoline);
}

extension LazyRunParserExtension<R> on Lazy<Parser<R>> {
  ///
  /// Runs a parser grammar using `PEG implementation`.
  /// Faster than GLL, but is more inline with handwritten recursive-descent parsers.
  ///
  Context<R> peg(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    PegHandler? handler,
  }) =>
      runParserPeg($(), input, build: build, tamper: tamper, end: end, handler: handler);

  ///
  /// Runs a parser grammar using `GLL implementation`.
  /// Contains a large overhead, but is able to parse all context-free grammars.
  ///
  Iterable<Context<R>> gll(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    Trampoline? trampoline,
  }) =>
      runParserGll($(), input, build: build, tamper: tamper, end: end, trampoline: trampoline);
}

extension PegRecognizeExtension<R> on PegRunFn<R> {
  ///
  /// Returns a [bool] which decides whenever a parser grammar
  /// `accepts` or `rejects` an input in `PEG specification`.
  ///
  bool recognize(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    PegHandler? handler,
  }) =>
      this(input, build: build, tamper: tamper, end: end, handler: handler) is Success;

  ///
  /// A helper method that changes the handler type of the `PEG specification`.
  ///
  /// Pros: Least overhead <br>
  /// Cons: Does not support any left-recursive grammars.
  ///
  Context<R> primitive(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    PegHandler? handler,
  }) =>
      this(
        input,
        build: build,
        tamper: tamper,
        end: end,
        handler: handler is PrimitiveHandler ? handler : PrimitiveHandler(),
      );

  ///
  /// A helper method that changes the handler type of the `PEG specification`.
  ///
  /// Pros: Supports direct left-recursion <br>
  /// Cons: Does not support any indirect left-recursive grammars.
  ///
  Context<R> linear(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    PegHandler? handler,
  }) =>
      this(
        input,
        build: build,
        tamper: tamper,
        end: end,
        handler: handler is LinearHandler ? handler : LinearHandler(),
      );

  ///
  /// A helper method that changes the handler type of the `PEG specification`.
  ///
  /// Pros: Supports indirect left-recursion <br>
  /// Cons: Has the most overhead.
  ///
  Context<R> quadratic(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    PegHandler? handler,
  }) =>
      this(
        input,
        build: build,
        tamper: tamper,
        end: end,
        handler: handler is QuadraticHandler ? handler : QuadraticHandler(),
      );
}

extension GllRecognizeExtension<R> on GllRunFn<R> {
  /// Returns a [bool] which decides whenever a parser grammar
  /// `accepts` or `rejects` an input in `GLL specification`.
  bool recognize(
    String input, {
    bool build = true,
    bool tamper = true,
    bool end = true,
    Trampoline? trampoline,
  }) =>
      this(input, build: build, tamper: tamper, end: end, trampoline: trampoline).first is Success;
}
