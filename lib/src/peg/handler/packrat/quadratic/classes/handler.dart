// ignore_for_file: deprecated_member_use_from_same_package

import "dart:collection";

import "package:parser_combinator/src/context.dart";
import "package:parser_combinator/src/extension/traverse.dart";
import "package:parser_combinator/src/parser.dart";
import "package:parser_combinator/src/peg/handler/abstract/handler.dart";
import "package:parser_combinator/src/peg/handler/packrat/primitive/handler.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/classes/head.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/classes/left_recursion.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/classes/memoization_entry.dart";
import "package:parser_combinator/src/peg/handler/packrat/quadratic/typedef.dart";

extension<R> on Context<R> {
  MemoizationEntry entry() => MemoizationEntry(this);
}

extension<R> on LeftRecursion<R> {
  MemoizationEntry entry() => MemoizationEntry(this);
}

class QuadraticHandler extends PegHandler {
  QuadraticHandler();

  @override
  factory QuadraticHandler.tokenize(Parser<void> root, String input, [Pattern? layout]) {
    PrimitiveHandler primitive = PrimitiveHandler.tokenize(root, input, layout);
    QuadraticHandler self = QuadraticHandler();
    for (Parser<void> parser in root.traverse().where((Parser<void> p) => p.children.isEmpty && p.isNotNullable)) {
      for (int index in primitive.table[parser].keys) {
        for (int indent in primitive.table[parser][index].keys) {
          self._table[parser][index][indent] = primitive.table[parser][index][indent]!.entry();
        }
      }
    }

    return self;
  }

  @pragma("vm:prefer-inline")
  @override
  Context<R> parse<R>(Parser<R> parser, Context<void> context) {
    return parser.captureGeneric(<G>(Parser<G> parser) {
      if (context is Failure) {
        return context;
      } else if (parser.pegMemoize) {
        return _memoized(parser, context) as Context<R>;
      } else {
        return parser.pegParseOn(context, this) as Context<R>;
      }
    });
  }

  final ParsingTable _table = createParsingTable();
  final Map<int, Head<void>> _heads = <int, Head<void>>{};
  final Queue<LeftRecursion<void>> _lrStack = Queue<LeftRecursion<void>>();

  MemoizationEntry? _recall<R>(Parser<R> parser, int index, Context<void> context) {
    MemoizationEntry? entry = _table[parser][context.indentation.first][index];
    Head<void>? head = _heads[index];

    // If the head is not being grown, return the memoized result.
    if (head == null || !head.evaluationSet.contains(parser)) {
      return entry;
    }

    // If the current parser is not a part of the head and is not evaluated yet,
    // Add a failure to it.
    if (entry == null || head.parser == parser || !head.involvedSet.contains(parser)) {
      return context.failure("seed").entry();
    }

    // Remove the current parser from the head's evaluation set.
    head.evaluationSet.remove(parser);
    entry.value = parser.pegParseOn(context, this);

    return entry;
  }

  Context<R> _lrResult<R>(Parser<R> parser, int index, MemoizationEntry entry) {
    LeftRecursion<R> leftRecursion = entry.value as LeftRecursion<R>;
    Head<void> head = leftRecursion.head!;
    Context<R> seed = leftRecursion.seed;

    /// If the rule of the parser is not the one being parsed,
    /// return the seed.
    if (head.parser != parser) {
      return seed;
    }

    /// Since it is the parser, assign it to the seed.
    Context<R> seedContext = entry.value = seed;
    if (seedContext is Failure) {
      return seedContext;
    }

    _heads[index] = head;

    /// "Grow the seed."
    for (;;) {
      head.evaluationSet.addAll(head.involvedSet);
      Context<R> result = parser.pegParseOn(seedContext.replaceIndex(index), this);
      if (result is Failure || result.index <= seedContext.index) {
        break;
      }
      entry.value = result;
    }
    _heads.remove(index);

    return entry.value as Context<R>;
  }

  Context<R> _memoized<R>(Parser<R> parser, Context<void> context) {
    int index = context.index;
    int indent = context.indentation.first;

    MemoizationEntry? entry = _recall(parser, index, context);
    if (entry == null) {
      Map<int, MemoizationEntry> subMap = _table[parser][indent];

      LeftRecursion<R> leftRecursion = LeftRecursion<R>(
        seed: context.failure("seed"),
        parser: parser,
        head: null,
      );

      _lrStack.addFirst(leftRecursion);

      entry = subMap[index] = leftRecursion.entry();
      Context<R> ans = parser.pegParseOn(context, this);

      _lrStack.removeFirst();

      if (leftRecursion.head != null) {
        leftRecursion.seed = ans;

        return _lrResult(parser, index, entry);
      } else {
        entry.value = ans;

        return ans;
      }
    } else {
      switch (entry.value) {
        case LeftRecursion<R> result:
          Head<void> head = result.head ??= (
            parser: parser,
            evaluationSet: <Parser<void>>{},
            involvedSet: <Parser<void>>{},
          );

          for (LeftRecursion<void> lr in _lrStack) {
            if (lr.head == head) {
              break;
            }

            head.involvedSet.add(lr.parser);
            lr.head = head;
          }

          return result.seed;
        case Context<R> result:
          return result;
        default:
          throw UnsupportedError("no u");
      }
    }
  }
}
