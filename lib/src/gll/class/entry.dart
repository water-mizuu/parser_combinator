import "dart:collection";

import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/gll/shared/typedef.dart";

///
/// A data class used in memoization in `GLL`.
///
class ParserEntry<R> {
  final List<Continuation<R>> continuations;
  final HashSet<Context<R>> results;

  ParserEntry()
      : continuations = <Continuation<R>>[],
        results = HashSet<Context<R>>();

  bool get isEmpty => continuations.isEmpty && results.isEmpty;
}
