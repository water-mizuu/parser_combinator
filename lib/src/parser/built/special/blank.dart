import "package:parser_combinator/parser_combinator.dart";

Parser<R> blank<R extends Object?>() => predicate(
      (Context<void> context) => context.failure("Blank"),
      toString: () => "blank",
      nullable: () => false,
    );
