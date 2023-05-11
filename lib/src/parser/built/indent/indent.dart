import "package:parser_combinator/parser_combinator.dart";

Parser<int> indent() {
  return predicate(
    (Context<void> context) {
      int previous = context.indentation.first;
      int indent = context.indent;

      if (indent > previous) {
        return context.success(indent).pushIndent(indent);
      } else {
        return context.failure("Expected an indentation. $indent -> $previous");
      }
    },
    toString: () => "indentation",
    nullable: () => true,
  );
}
