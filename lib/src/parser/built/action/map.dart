import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/action/piped.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

Parser<R> _map<R, C>(Parser<C> parser, MappedParserFunction<R, C> visitor, {bool force = false}) {
  return parser.pipe(toString: () => "MappedParser", (_, context) {
    if (context is Success<C>) {
      R result = visitor(context.value);

      return context.success(result, context.cst);
    }
    return context as Context<Never>;
  });
}

extension MappedParser<C> on Parser<C> {
  Parser<R> map<R>(MappedParserFunction<R, C> function, {bool force = false}) => _map(this, function, force: force);
}
