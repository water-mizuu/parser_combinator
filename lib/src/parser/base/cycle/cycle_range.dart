import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/context/empty.dart";
import "package:parser_combinator/src/context/failure.dart";
import "package:parser_combinator/src/context/success.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

class CycleRangeParser<R> extends Parser<List<R>> with WrappingParser<List<R>, R> {
  @override
  final List<Parser<R>> children;
  final num min;
  final num max;

  CycleRangeParser(Parser<R> parser, this.min, this.max) : children = [parser];
  CycleRangeParser._empty(this.min, this.max) : children = [];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<List<R>> continuation) {
    void _parseMaximum(Context<void> context, num count, List<R> results, List<Object?> cst) {
      if (count <= max) {
        continuation(context.success(results));
      }

      if (count < max) {
        /// Unbounded loop.
        ///   Basically, it doesn't terminate lmao
        trampoline.add(child, context, (result) {
          if (result is Success<R>) {
            return _parseMaximum(result, count + 1, [...results, result.value], [...cst, result.cst]);
          } else if (result is Empty) {
            return _parseMaximum(result, count + 1, results, [...cst, result.cst]);
          }
        });
      }
    }

    void _parseMinimum(Context<void> context, int count, List<R> results, List<Object?> cst) {
      if (count >= min) {
        return _parseMaximum(context, count, results, cst);
      }

      trampoline.add(child, context, (result) {
        if (result is Failure) {
          return continuation(result);
        } else if (result is Success<R>) {
          return _parseMinimum(result, count + 1, [...results, result.value], [...cst, result.cst]);
        } else if (result is Empty) {
          return _parseMinimum(result, count + 1, results, [...cst, result.cst]);
        }
      });
    }

    return _parseMinimum(context, 0, [], []);
  }

  @override
  Context<List<R>> pegParseOn(Context<void> context, PegHandler handler) {
    List<R> results = [];
    List<Object?> cst = [];

    Context<void> ctx = context;
    int i = 0;
    for (; i < min; ++i) {
      Context<R> result = handler.parse(child, ctx);
      if (result is Failure) {
        return result;
      } else if (result is Success<R>) {
        results.add(result.value);
      }
      cst.add(result.cst);

      ctx = result;
    }

    for (; i < max; ++i) {
      Context<R> result = handler.parse(child, ctx);
      if (result is Failure) {
        return result.success(results, cst);
      } else if (result is Success<R>) {
        results.add(result.value);
      }
      cst.add(result.cst);
      ctx = result;
    }

    return ctx.success(results, cst);
  }

  @override
  CycleRangeParser<R> generateEmpty() {
    return CycleRangeParser._empty(min, max);
  }
}

extension CycleRangeParserExtension<R> on Parser<R> {
  Parser<List<R>> range(num min, num max) => CycleRangeParser(this, min, max);
}
