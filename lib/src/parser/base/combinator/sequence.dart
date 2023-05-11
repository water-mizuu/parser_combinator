import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/sequential_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

///
/// [Parser] that describes sequencing.
///
class SequenceParser<R> extends Parser<List<R>> with SequentialParser<List<R>, R> {
  @override
  final List<Parser<R>> children;

  SequenceParser(this.children);
  SequenceParser._empty() : children = <Parser<R>>[];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<List<R>> continuation) {
    void _continue(Context<void> context, int index, List<R> accumulativeResults, List<Object?> accumulativeCst) {
      if (index >= children.length) {
        return continuation(context.success(accumulativeResults, accumulativeCst));
      }

      trampoline.add(children[index], context, (Context<R> result) {
        switch (result) {
          case Failure _:
            return continuation(result);
          case Success(:R value, :Object? cst):
            return _continue(
              result,
              index + 1,
              <R>[...accumulativeResults, value],
              <Object?>[...accumulativeCst, cst],
            );
          case Empty(:Object? cst):
            return _continue(
              result,
              index + 1,
              accumulativeResults,
              <Object?>[...accumulativeCst, cst],
            );
        }
      });
    }

    _continue(context, 0, <R>[], <Object?>[]);
  }

  @override
  Context<List<R>> pegParseOn(Context<void> context, PegHandler handler) {
    List<R> results = <R>[];
    List<Object?> cst = <Object?>[];

    Context<void> ctx = context;
    for (int i = 0; i < children.length; ++i) {
      Context<R> inner = handler.parse(children[i], ctx);
      if (inner case Failure _) {
        return inner;
      } else if (inner case Success _) {
        results.add(inner.value);
      }
      cst.add(inner.cst);
      ctx = inner;
    }

    return ctx.success(results, cst);
  }

  @override
  SequenceParser<R> generateEmpty() {
    return SequenceParser<R>._empty();
  }
}

SequenceParser<R> sequence<R extends Object?>(List<Parser<R>> parsers) => SequenceParser<R>(parsers);

extension SequenceParserExtension<R> on Parser<R> {
  Parser<List<Object?>> operator &(Parser<Object?> other) {
    Parser<R> self = this;

    return SequenceParser<Object?>(<Parser<Object?>>[self, other]);
  }
}

extension NonNullableSequenceParserExtension<R extends Object> on Parser<R> {
  Parser<List<Object>> operator +(Parser<Object> other) {
    Parser<R> self = this;

    return SequenceParser<Object>(<Parser<Object>>[self, other]);
  }
}

extension ExtendedSequenceParserExtension<R> on Parser<List<R>> {
  Parser<List<Object?>> operator &(Parser<Object?> other) {
    Parser<List<R>> self = this;

    if (self is SequenceParser<R>) {
      return SequenceParser<Object?>(<Parser<Object?>>[...self.children, other]);
    } else {
      return SequenceParser<Object?>(<Parser<Object?>>[self, other]);
    }
  }
}

extension NonNullableExtendedSequenceParserExtension<R extends Object> on Parser<List<R>> {
  Parser<List<Object>> operator +(Parser<Object> other) {
    Parser<List<R>> self = this;

    if (self is SequenceParser<R>) {
      return SequenceParser<Object>(<Parser<Object>>[...self.children, other]);
    } else {
      return SequenceParser<Object>(<Parser<Object>>[self, other]);
    }
  }
}

extension IterableSequenceParserExtension<R> on Iterable<Parser<R>> {
  Parser<List<R>> sequence() => SequenceParser<R>(<Parser<R>>[...this]);
}
