import "package:parser_combinator/parser_combinator.dart";

Parser<int> samedent() {
  return predicate(
    (context) {
      int previous = context.indentation.first;
      int indent = context.indent;

      if (indent == previous) {
        return context.success(indent);
      } else {
        return context.failure("Expected a consistent indentation. $indent -> $previous");
      }
    },
    toString: () => "same-indentation",
    nullable: () => true,
  );
}
