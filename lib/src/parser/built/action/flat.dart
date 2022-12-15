import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/context/success.dart";
import "package:parser_combinator/src/parser/base/action/piped.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

Parser<String> _flat<C>(Parser<C> parser) {
  return parser.pipe(toString: () => "FlattenedParser", (pre, context) {
    if (context is Success<C>) {
      int start = pre.index;
      int end = context.index;

      return context.success(context.input.substring(start, end), context.cst);
    }
    return context as Context<Never>;
  });
}

extension FlattenedParser<C> on Parser<C> {
  Parser<String> flat() => _flat(this);
}
