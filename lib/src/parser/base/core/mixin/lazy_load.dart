import "package:meta/meta.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

base mixin LazyLoad<R> on Parser<R> {
  abstract final Lazy<Parser<R>> lazyParser;
  late Parser<R> computed = lazyParser();

  @nonVirtual
  @override
  List<Parser<R>> get children => <Parser<R>>[computed];

  @nonVirtual
  @override
  LazyLoad<R> createClone(ParserCache cloned) => eager(computed.selfClone(cloned));

  @nonVirtual
  @override
  LazyLoad<R> transformChildren(TransformFunction handler, ParserCache cache) =>
      this..computed = computed.selfTransform(handler, cache);

  LazyLoad<R> eager(Parser<R> parser);

  @override
  bool computeNullable(ParserBooleanCache cache) => computed.selfIsNullable(cache);
}
