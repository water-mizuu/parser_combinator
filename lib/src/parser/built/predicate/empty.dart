import "package:parser_combinator/parser_combinator.dart";

Parser<R> empty<R>() {
  return predicate(
    (Context<void> context) => context.empty(),
    toString: () => "empty",
    nullable: () => true,
  );
}
