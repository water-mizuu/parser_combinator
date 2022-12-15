import "dart:collection";

import "package:parser_combinator/parser_combinator.dart";
import "package:parser_combinator/src/gll/class/action.dart";
import "package:parser_combinator/src/gll/class/call.dart";
import "package:parser_combinator/src/gll/class/continue.dart";

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
    parser.captureGeneric(<C>(parser) {
      Continuation<C> _continuation = continuation as Continuation<C>;
      ParserEntry<C> entry = table //
          .putIfAbsent(parser, HashMap.new)
          .putIfAbsent(context.indentation.first, HashMap.new)
          .putIfAbsent(context.index, ParserEntry<C>.new) as ParserEntry<C>;

      if (entry.isEmpty) {
        entry.continuations.add(_continuation);
        stack.add(CallAction(parser, context, (result) {
          if (entry.results.add(result)) {
            for (int i = 0; i < entry.continuations.length; ++i) {
              stack.add(ContinueAction(result, entry.continuations[i]));
            }
          }
        }));
      } else {
        entry.continuations.add(_continuation);
        for (Context<C> result in entry.results) {
          stack.add(ContinueAction(result, _continuation));
        }
      }
    });
  }
}
