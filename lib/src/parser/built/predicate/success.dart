import "package:parser_combinator/parser_combinator.dart";

Parser<R> success<R>(R value) {
  return predicate(
    (Context<void> context) => context.success(value),
    toString: () => "success($value)",
    nullable: () => true,
  );
}
