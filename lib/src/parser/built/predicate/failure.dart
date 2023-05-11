import "package:parser_combinator/parser_combinator.dart";

Parser<R> failure<R>(String message) {
  return predicate(
    (Context<void> context) => context.failure(message),
    toString: () => "failure",
    nullable: () => false,
  );
}
