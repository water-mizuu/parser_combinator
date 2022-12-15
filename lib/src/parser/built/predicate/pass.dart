import "package:parser_combinator/parser_combinator.dart";

Parser<R> pass<R>(Context<R> context) {
  return predicate((_) => context);
}
