import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/combinator_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

///
/// Choice [Parser] that describes alternative.
///
base class ChoiceParser<R> extends Parser<R> with CombinatorParser<R> {
  @override
  final List<Parser<R>> children;

  ChoiceParser(this.children);
  ChoiceParser._empty() : children = <Parser<R>>[];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    for (Parser<R> parser in children) {
      trampoline.add(parser, context, continuation);
    }
  }

  @override
  Context<R> pegParseOn(Context<void> context, PegHandler handler) {
    for (int i = 0; i < children.length; ++i) {
      Context<R> result = handler.parse(children[i], context);
      if (result is Success) {
        return result;
      }
      if (result is Failure) {
        handler.failure(result.failure());
      }
    }

    return handler.longestFailure;
  }

  @override
  ChoiceParser<R> generateEmpty() {
    return ChoiceParser<R>._empty();
  }
}

///
/// Helper method for the [ChoiceParser] constructor.
///
ChoiceParser<R> choice<R>(Iterable<Parser<R>> parsers) => ChoiceParser<R>(parsers.toList());

// extension StringChoiceParserExtension on Parser<String> {}

extension ChoiceParserExtension<R> on Parser<R> {
  Parser<Object?> operator |(Parser<Object?> other) => switch (this) {
        ChoiceParser<R>(:List<Parser<R>> children) => ChoiceParser<Object?>(<Parser<Object?>>[...children, other]),
        Parser<R> self => ChoiceParser<Object?>(<Parser<Object?>>[self, other]),
      };

  Parser<R> operator /(Parser<R> other) => switch (this) {
        ChoiceParser<R>(:List<Parser<R>> children) => ChoiceParser<R>(<Parser<R>>[...children, other]),
        Parser<R> self => ChoiceParser<R>(<Parser<R>>[self, other]),
      };

  Parser<Object?> or(Parser<Object?> other) => this | other;
}

extension NonNullableChoiceParserExtension<R extends Object> on Parser<R> {
  Parser<R> operator |(Parser<R> other) => switch (this) {
        ChoiceParser<R>(:List<Parser<R>> children) => ChoiceParser<R>(<Parser<R>>[...children, other]),
        Parser<R> self => ChoiceParser<R>(<Parser<R>>[self, other]),
      };

  Parser<Object> operator /(Parser<Object> other) => switch (this) {
        ChoiceParser<Object>(:List<Parser<Object>> children) =>
          ChoiceParser<Object>(<Parser<Object>>[...children, other]),
        Parser<Object> self => ChoiceParser<Object>(<Parser<Object>>[self, other]),
      };
}

extension ListChoiceParserExtension<R> on Iterable<Parser<R>> {
  Parser<R> choice() => ChoiceParser<R>(toList());
}

extension ChoiceBuilderParserExtension on ChoiceParser<R> Function<R>(Iterable<Parser<R>> parsers) {
  ChoiceParser<R> builder<R>(Iterable<Parser<R>> Function() builder) => this(builder());
}
