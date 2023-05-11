import "package:parser_combinator/parser_combinator.dart";

Parser<String> startOfInput() {
  return predicate(
    (Context<void> context) {
      if (context.index <= 0) {
        return context.success("start-of-input");
      }
      return context.failure("Expected start of input.");
    },
    toString: () => "start-of-input",
  );
}

extension StartParserExtension<R> on Parser<R> {
  Parser<R> start() => sequence(<Parser<Object?>>[startOfInput(), this]).map((List<Object?> $) => $[0].cast());
}
