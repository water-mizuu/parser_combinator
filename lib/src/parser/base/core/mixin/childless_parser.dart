import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

base mixin ChildlessParser<R> on Parser<R> {
  bool get nullable;

  @override
  bool computeNullable(ParserBooleanCache cache) {
    return nullable;
  }

  @override
  Parser<R> createClone(ParserCache cache) {
    return this;
  }

  @override
  Parser<R> transformChildren(TransformFunction function, ParserCache cache) {
    return this;
  }

  @override
  List<Parser<void>> get children => <Parser<void>>[];
}
