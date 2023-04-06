import "package:parser_combinator/parser_combinator.dart";
import "package:parser_combinator/src/shared/multi_map.dart";

enum TrieMode { lazy, greedy }

Parser<String> _trie(Iterable<String> strings, {String? message, TrieMode? mode}) {
  message ??= "Trie matcher failed.";
  mode ??= TrieMode.greedy;

  Trie trie = Trie.from(strings);

  return predicate(
    (context) {
      var Context<void>(:String input, :int index) = context;
      List<int> ends = [];

      Trie? derivation = trie;
      for (int i = index; i < input.length; ++i) {
        derivation = derivation?.derive(input[i]);
        if (derivation == null) {
          break;
        }

        if (derivation.hasIntermediate) {
          ends.add(i);

          if (mode == TrieMode.lazy) {
            break;
          }
        }
      }

      if (ends.isEmpty) {
        return context.failure(message);
      }

      int max = ends.last + 1;
      String substring = input.substring(index, max);

      return context.success(substring).replaceIndex(max);
    },
    toString: () => "TrieParser[${strings.length}]",
    nullable: () => trie.hasIntermediate,
  );
}

/// Returns a parser which uses a [Trie] data structure for more
/// efficient matching of multiple [strings]. Effective for parsing
/// hundreds / large amounts of "keywords". Takes the longest match
/// / shortest match depending on the mode. The two valid modes are
/// ```
/// enum TrieMode { lazy, greedy }
/// ```
Parser<String> trie(Iterable<String> strings, {String? message, TrieMode? mode}) =>
    _trie(strings, message: message, mode: mode);

extension TrieParserIterableStringExtension on Iterable<String> {
  Parser<String> trie({String? message, TrieMode? mode}) => _trie(this, message: message, mode: mode);
}

extension TrieParserExtendedExtension on Parser<String> Function({String? message, TrieMode? mode}) {
  Parser<String> lazy({String? message, TrieMode? mode}) => this(message: message, mode: TrieMode.lazy);
  Parser<String> greedy({String? message, TrieMode? mode}) => this(message: message, mode: TrieMode.greedy);
}

extension TrieParserFunctionExtension on Parser<String> Function(
  Iterable<String> strings, {
  String? message,
  TrieMode? mode,
}) {
  Parser<String> lazy(Iterable<String> strings, {String? message, TrieMode? mode}) =>
      this(strings, message: message, mode: TrieMode.lazy);
  Parser<String> greedy(Iterable<String> strings, {String? message, TrieMode? mode}) =>
      this(strings, message: message, mode: TrieMode.greedy);
}
