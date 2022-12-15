import "package:parser_combinator/parser_combinator.dart";

Parser<R> failure<R>(String message) {
  return predicate((context) => context.failure(message));
}
