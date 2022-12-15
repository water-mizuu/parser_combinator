import "package:parser_combinator/parser_combinator.dart";

///
/// An extension of the [ChoiceParser], with the main difference
/// being that [FirstChoiceParser] only yields one result.
///
class FirstChoiceParser<R> extends ChoiceParser<R> {
  FirstChoiceParser(super.children);

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    void _add(int i) {
      if (i >= children.length) {
        return continuation(context.failure("First Choice Failure"));
      }

      trampoline.add(children[i], context, (result) {
        if (result is Failure && i < children.length - 1) {
          _add(i + 1);
        } else {
          return continuation(result);
        }
      });
    }

    _add(0);
  }
}

extension ListFirstChoiceParserExtension<R> on Iterable<Parser<R>> {
  Parser<R> firstChoice() => FirstChoiceParser(toList());
}
