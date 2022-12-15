import "package:parser_combinator/parser_combinator.dart";

Parser<int> dedent() {
  return predicate(
    (context) {
      if (context.index >= context.input.length) {
        if (context.indentation.length > 1) {
          return context.success(0).popIndent();
        } else {
          return context.success(0);
        }
      }

      int indent = context.indent;
      bool legal = context.indentation.isNotEmpty && context.indentation.sublist(1).contains(indent);
      if (indent < context.indentation[0]) {
        if (legal) {
          return context.success(indent).popIndent();
        } else {
          return context.failure("Illegal dedentation. $indent -> ${context.indentation[1]}");
        }
      } else {
        return context.failure("Expected an dedentation. $indent -> ${context.indentation[0]}");
      }
    },
    toString: () => "dedentation",
    nullable: () => true,
  );
}
