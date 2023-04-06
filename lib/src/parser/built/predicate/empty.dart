import "package:parser_combinator/parser_combinator.dart";

Parser<R> empty<R>() {
  return predicate(
    (context) => context.empty(),
    toString: () => "empty",
    nullable: () => true,
  );
}
