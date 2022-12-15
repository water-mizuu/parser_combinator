import "package:parser_combinator/parser_combinator.dart";

mixin SequentialParser<O, R> on Parser<O> {
  SequentialParser<O, R> generateEmpty();

  @override
  SequentialParser<O, R> createClone(ParserCache cache) {
    SequentialParser<O, R> clone = cache[this] = generateEmpty();
    for (int i = 0; i < children.length; ++i) {
      clone.children.add(children[i].selfClone(cache));
    }

    return clone;
  }

  @override
  SequentialParser<O, R> transformChildren(TransformFunction function, ParserCache cache) {
    cache[this] = this;
    for (int i = 0; i < children.length; ++i) {
      children[i] = children[i].selfTransform(function, cache);
    }

    return this;
  }

  @override
  bool computeNullable(ParserBooleanCache cache) {
    bool nullable = cache[this] = true;
    for (int i = 0; nullable && i < children.length; ++i) {
      nullable &= children[i].selfIsNullable(cache);
    }
    return nullable;
  }
}
