import "package:parser_combinator/parser_combinator.dart";

///
/// An extension of the [ChoiceParser], with the main difference
/// being that [FirstChoiceParser] only yields one result.
///
class FirstChoiceParser<R> extends ChoiceParser<R> {
  FirstChoiceParser(super.children);

  @override
  void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<R> continuation) {
    void _add(int iteration) {
      if (iteration >= children.length) {
        return continuation(context.failure("First Choice Failure"));
      }

      trampoline.add(children[iteration], context, (result) {
        if (result case Failure() when iteration < children.length - 1) {
          _add(iteration + 1);
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
