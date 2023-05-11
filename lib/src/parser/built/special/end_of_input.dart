import "package:parser_combinator/parser_combinator.dart";

Parser<String> endOfInput() {
  return predicate(
    (Context<void> context) {
      if (context.index >= context.input.length) {
        return context.success("end-of-input");
      }
      return context.failure("Expected end of input.");
    },
    toString: () => "end-of-input",
  );
}

extension EndParserExtension<R> on Parser<R> {
  Parser<R> end() => sequence(<Parser<Object?>>[this, endOfInput()]).map((List<Object?> $) => $[0].cast());
}
