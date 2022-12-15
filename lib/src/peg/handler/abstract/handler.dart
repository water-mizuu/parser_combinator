// ignore_for_file: avoid_returning_this

import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/context/failure.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

abstract class PegHandler {
  Context<R> parse<R>(Parser<R> parser, Context<void> context);

  Failure longestFailure = const Failure("Base failure", "", -1);
  Failure failure(Failure ctx) => longestFailure = _determineFailure(ctx, longestFailure);

  static Failure _determineFailure(Failure ctx, Failure? longestFailure) {
    if (longestFailure == null) {
      return ctx;
    }
    const String memoError = "seed";

    if (ctx.message == memoError) {
      return longestFailure;
    } else if (longestFailure.message == memoError) {
      return ctx;
    }

    if (ctx.artificial ^ longestFailure.artificial) {
      return ctx.artificial ? ctx : longestFailure;
    }

    return ctx.index > longestFailure.index ? ctx : longestFailure;
  }
}
