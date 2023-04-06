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
  SequenceParser._empty() : children = [];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<List<R>> continuation) {
    void _continue(Context<void> context, int index, List<R> accumulativeResults, List<Object?> accumulativeCst) {
      if (index >= children.length) {
        return continuation(context.success(accumulativeResults, accumulativeCst));
      }

      trampoline.add(children[index], context, (result) {
        switch (result) {
          case Failure _:
            return continuation(result);
          case Success(:R value, :Object? cst):
            return _continue(result, index + 1, [...accumulativeResults, value], [...accumulativeCst, cst]);
          case Empty(:Object? cst):
            return _continue(result, index + 1, accumulativeResults, [...accumulativeCst, cst]);
        }
      });
    }

    _continue(context, 0, [], []);
  }

  @override
  Context<List<R>> pegParseOn(Context<void> context, PegHandler handler) {
    List<R> results = [];
    List<Object?> cst = [];

    Context<void> ctx = context;
    for (int i = 0; i < children.length; ++i) {
      Context<R> inner = handler.parse(children[i], ctx);
      if (inner is Failure) {
        return inner;
      } else if (inner is Success) {
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

    return SequenceParser<Object?>([self, other]);
  }
}

extension NonNullableSequenceParserExtension<R extends Object> on Parser<R> {
  Parser<List<Object>> operator +(Parser<Object> other) {
    Parser<R> self = this;

    return SequenceParser<Object>([self, other]);
  }
}

extension ExtendedSequenceParserExtension<R> on Parser<List<R>> {
  Parser<List<Object?>> operator &(Parser<Object?> other) {
    Parser<List<R>> self = this;

    if (self is SequenceParser<R>) {
      return SequenceParser<Object?>([...self.children, other]);
    } else {
      return SequenceParser<Object?>([self, other]);
    }
  }
}

extension NonNullableExtendedSequenceParserExtension<R extends Object> on Parser<List<R>> {
  Parser<List<Object>> operator +(Parser<Object> other) {
    Parser<List<R>> self = this;

    if (self is SequenceParser<R>) {
      return SequenceParser<Object>([...self.children, other]);
    } else {
      return SequenceParser<Object>([self, other]);
    }
  }
}

extension IterableSequenceParserExtension<R> on Iterable<Parser<R>> {
  Parser<List<R>> sequence() => SequenceParser<R>([...this]);
}
