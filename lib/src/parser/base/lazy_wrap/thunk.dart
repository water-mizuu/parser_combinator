import "dart:collection";

import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/lazy_load.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";
import "package:parser_combinator/src/shared/typedef.dart";

part "thunk_extension.dart";

typedef _ThunkMap = HashMap<Lazy<Parser<void>>, ReferenceParser<void>>;

base class ReferenceParser<R> extends Parser<R> with LazyLoad<R> {
  static final _ThunkMap _thunkMap = _ThunkMap();

  @override
  final Lazy<Parser<R>> lazyParser;

  factory ReferenceParser(Lazy<Parser<R>> lazyParser) =>
      (_thunkMap[lazyParser] ??= ReferenceParser<R>._(lazyParser)) as ReferenceParser<R>;

  ReferenceParser._(this.lazyParser);
  ReferenceParser.eager(Parser<R> parser) //
      : lazyParser = (() => throw UnsupportedError("This instance has been created using ReferenceParser.eager")) {
    computed = parser;
  }

  @override
  LazyLoad<R> eager(Parser<R> parser) => ReferenceParser<R>.eager(parser);

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    trampoline.add(computed, context, continuation);
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) {
    return handler.parse(computed, context);
  }
}
