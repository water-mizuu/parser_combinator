import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/context/empty.dart";
import "package:parser_combinator/src/context/failure.dart";
import "package:parser_combinator/src/context/success.dart";
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
    void _continue(Context<void> context, int index, List<R> results, List<Object?> cst) {
      if (index >= children.length) {
        return continuation(context.success(results, cst));
      }
      trampoline.add(children[index], context, (result) {
        if (result is Failure) {
          return continuation(result);
        } else if (result is Success<R>) {
          return _continue(result, index + 1, [...results, result.value], [...cst, result.cst]);
        } else if (result is Empty) {
          return _continue(result, index + 1, results, [...cst, result.cst]);
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
    return SequenceParser._empty();
  }
}

SequenceParser<R> sequence<R extends Object?>(List<Parser<R>> parsers) => SequenceParser(parsers);

extension SequenceParserExtension<R> on Parser<R> {
  Parser<List<Object?>> operator &(Parser<Object?> other) {
    Parser<R> self = this;

    return SequenceParser([self, other]);
  }
}

extension NonNullableSequenceParserExtension<R extends Object> on Parser<R> {
  Parser<List<Object>> operator +(Parser<Object> other) {
    Parser<R> self = this;

    return SequenceParser([self, other]);
  }
}

extension ExtendedSequenceParserExtension<R> on Parser<List<R>> {
  Parser<List<Object?>> operator &(Parser<Object?> other) {
    Parser<List<R>> self = this;

    if (self is SequenceParser<R>) {
      return SequenceParser([...self.children, other]);
    } else {
      return SequenceParser([self, other]);
    }
  }
}

extension NonNullableExtendedSequenceParserExtension<R extends Object> on Parser<List<R>> {
  Parser<List<Object>> operator +(Parser<Object> other) {
    Parser<List<R>> self = this;

    if (self is SequenceParser<R>) {
      return SequenceParser([...self.children, other]);
    } else {
      return SequenceParser([self, other]);
    }
  }
}

extension IterableSequenceParserExtension<R> on Iterable<Parser<R>> {
  Parser<List<R>> sequence() => SequenceParser([...this]);
}
