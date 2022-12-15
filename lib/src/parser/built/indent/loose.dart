import "package:parser_combinator/parser_combinator.dart";

Parser<int> loosedent() {
  return predicate(
    (context) {
      int previous = context.indentation.first;
      int indent = context.indent;

      if (indent >= previous) {
        return context.success(indent);
      } else {
        return context.failure("Expected a loosely consistent indentation. $indent -> $previous");
      }
    },
    toString: () => "loose-indentation",
    nullable: () => true,
  );
}
