import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/class/trampoline.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/base/core/mixin/wrapping_parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";

base class CycleRangeParser<R> extends Parser<List<R>> with WrappingParser<List<R>, R> {
  @override
  final List<Parser<R>> children;
  final num min;
  final num max;

  CycleRangeParser(Parser<R> parser, this.min, this.max) : children = <Parser<R>>[parser];
  CycleRangeParser._empty(this.min, this.max) : children = <Parser<R>>[];

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<List<R>> continuation) {
    void _parseMaximum(Context<void> context, num count, List<R> results, List<Object?> cst) {
      if (count <= max) {
        continuation(context.success(results));
      }

      if (count < max) {
        /// Unbounded loop.
        ///   Basically, it doesn't terminate lmao

        trampoline.add(child, context, (Context<R> result) {
          if (result case Success<R>(:R value, cst: Object? _cst)) {
            _parseMaximum(result, count + 1, <R>[...results, value], <Object?>[...cst, _cst]);
          } else if (result case Empty(cst: Object? _cst)) {
            _parseMaximum(result, count + 1, results, <Object?>[...cst, _cst]);
          }
        });
      }
    }

    void _parseMinimum(Context<void> context, int count, List<R> results, List<Object?> cst) {
      if (count >= min) {
        return _parseMaximum(context, count, results, cst);
      }

      trampoline.add(child, context, (Context<R> result) {
        if (result case Failure()) {
          continuation(result);
        } else if (result case Success<R>(:R value, cst: Object? _cst)) {
          _parseMinimum(result, count + 1, <R>[...results, value], <Object?>[...cst, _cst]);
        } else if (result case Empty(cst: Object? _cst)) {
          _parseMinimum(result, count + 1, results, <Object?>[...cst, _cst]);
        }
      });
    }

    return _parseMinimum(context, 0, <R>[], <Object?>[]);
  }

  @override
  Context<List<R>> pegParseOn(Context<void> context, PegHandler handler) {
    List<R> results = <R>[];
    List<Object?> cst = <Object?>[];

    Context<void> ctx = context;
    int i = 0;
    for (; i < min; ++i) {
      Context<R> result = handler.parse(child, ctx);
      if (result case Failure()) {
        return result;
      } else if (result case Success<R>(:R value)) {
        results.add(value);
      }
      cst.add(result.cst);

      ctx = result;
    }

    for (; i < max; ++i) {
      Context<R> result = handler.parse(child, ctx);
      if (result case Failure()) {
        return ctx.success(results, cst);
      } else if (result case Success<R>(:R value)) {
        results.add(value);
      }
      cst.add(result.cst);
      ctx = result;
    }

    return ctx.success(results, cst);
  }

  @override
  CycleRangeParser<R> generateEmpty() {
    return CycleRangeParser<R>._empty(min, max);
  }
}

extension CycleRangeParserExtension<R> on Parser<R> {
  Parser<List<R>> range(num min, num max) => CycleRangeParser<R>(this, min, max);
}
