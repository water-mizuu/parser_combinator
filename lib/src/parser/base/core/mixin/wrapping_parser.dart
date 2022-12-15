import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

mixin WrappingParser<R, C> on Parser<R> {
  Parser<C> get child => children[0] as Parser<C>;

  WrappingParser<R, C> generateEmpty();

  @override
  WrappingParser<R, C> createClone(ParserCache cache) {
    WrappingParser<R, C> clone = cache[this] = generateEmpty();
    for (int i = 0; i < children.length; ++i) {
      clone.children.add(children[i].selfClone(cache));
    }

    return clone;
  }

  @override
  WrappingParser<R, C> transformChildren(TransformFunction function, ParserCache cache) {
    cache[this] = this;
    for (int i = 0; i < children.length; ++i) {
      children[i] = children[i].selfTransform(function, cache);
    }

    return this;
  }

  @override
  bool computeNullable(ParserBooleanCache cache) {
    bool nullable = cache[this] = false;
    for (int i = 0; !nullable && i < children.length; ++i) {
      nullable |= children[i].selfIsNullable(cache);
    }
    return nullable;
  }
}
