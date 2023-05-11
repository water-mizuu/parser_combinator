import "package:parser_combinator/parser_combinator.dart";
import "package:parser_combinator/parser_combinator.dart" as core;

abstract class Parser<R extends Object?> {
  bool pegMemoize = false;

  Context<R> pegParseOn(Context<void> context, PegHandler handler);
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation);

  Parser<R> createClone(ParserCache cache);
  Parser<R> selfClone([ParserCache? cache]) => //
      ((cache ??= ParserCache())[this] ??= createClone(cache) //
        ..pegMemoize = pegMemoize) as Parser<R>;

  Parser<R> transformChildren(TransformFunction function, ParserCache cache);
  Parser<R> selfTransform(TransformFunction handler, [ParserCache? cache]) =>
      ((cache ??= ParserCache())[this] ??= handler<R>(transformChildren(handler, cache))) //
          as Parser<R>;

  bool computeNullable(ParserBooleanCache cache);
  bool selfIsNullable([ParserBooleanCache? cache]) => //
      (cache ??= ParserBooleanCache())[this] ??= computeNullable(cache);

  List<Parser<void>> get children;
  O captureGeneric<O>(O Function<R>(Parser<R> parser) function) => function<R>(this);

  @override
  String toString() => runtimeType.toString();

  static Parser<String> end() => core.endOfInput();
  static Parser<String> start() => core.startOfInput();
  static Parser<String> empty() => core.epsilon();
  static Parser<int> newline() => core.string("\n").plus().map((List<String> v) => v.length);
  static Parser<int> indent() => core.indent();
  static Parser<int> samedent() => core.samedent();
  static Parser<int> dedent() => core.dedent();

  static Pattern layout = RegExp(r"[ \t]*");
  static Parser<String> token(String token) => string(token).trim(layout, layout);

  static bool isTerminal(Parser<void> parser) => parser.isTerminal;
  static bool isNotTerminal(Parser<void> parser) => parser.isNotTerminal;

  static bool isNullable(Parser<void> parser) => parser.isNullable;
  static bool isNotNullable(Parser<void> parser) => parser.isNotNullable;
}

extension ExtendedParserMethods<P extends Parser<Object?>> on P {
  static final Expando<bool> _isTerminals = Expando<bool>();
  static final Expando<bool> _isNullables = Expando<bool>();

  bool get _isTerminal => _isTerminals[this] ??= children.isEmpty;
  bool get _isNullable => _isNullables[this] ??= selfIsNullable();

  bool get isTerminal => _isTerminal;
  bool get isNotTerminal => !_isTerminal;
  bool get isNullable => _isNullable;
  bool get isNotNullable => !_isNullable;

  P clone() => selfClone() as P;
  P transform(TransformFunction handler) => selfTransform(handler) as P;
}
