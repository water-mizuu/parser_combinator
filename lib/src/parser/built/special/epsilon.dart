import "package:parser_combinator/parser_combinator.dart";

final Parser<String> _epsilonSingleton = predicate(
  (Context<void> context) => context.success(""),
  toString: () => "epsilon",
  nullable: () => true,
);

Parser<String> epsilon() => _epsilonSingleton;
