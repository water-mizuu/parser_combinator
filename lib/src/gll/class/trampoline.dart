import "dart:collection";

import "package:parser_combinator/parser_combinator.dart";
import "package:parser_combinator/src/gll/class/action.dart";

///
/// Class that simulates tail call optimization using
/// continuation-passing style callbacks.
///
class Trampoline {
  final Queue<ParserAction> stack;
  final MemoizationTable table;

  Trampoline()
      : stack = Queue<ParserAction>(),
        table = MemoizationTable();

  bool get hasNext => stack.isNotEmpty;

  ///
  /// Removes one [ParserAction] from the stack,
  /// calling it, and letting it process.
  ///
  void step() {
    if (hasNext) {
      stack.removeLast().call(this);
    }
  }

  ///
  /// Removes a [ParserAction] from the stack while it is not empty,
  /// calling each one, effectively finishing the parsing process.
  ///
  void run() {
    while (hasNext) {
      step();
    }
  }

  ///
  /// Pushes a [Parser] into the `GLL process`.
  ///
  void add<R>(Parser<R> parser, Context<void> context, Continuation<R> continuation) {
    parser.captureGeneric(<C>(Parser<C> parser) {
      Continuation<C> _continuation = continuation as Continuation<C>;

      var ParserEntry<C>(
        :bool isEmpty,
        :List<Continuation<C>> continuations,
        :HashSet<Context<C>> results,
      ) = table
          .putIfAbsent(parser, HashMap.new)
          .putIfAbsent(context.indentation.first, HashMap.new)
          .putIfAbsent(context.index, ParserEntry<C>.new) as ParserEntry<C>;

      if (isEmpty) {
        continuations.add(_continuation);
        stack.add(CallAction<C>(parser, context, (Context<C> result) {
          if (results.add(result)) {
            for (Continuation<C> continuation in continuations) {
              stack.add(ContinueAction<C>(result, continuation));
            }
          }
        }));
      } else {
        continuations.add(_continuation);
        for (Context<C> result in results) {
          stack.add(ContinueAction<C>(result, _continuation));
        }
      }
    });
  }
}
