import "package:parser_combinator/src/context/success.dart";
import "package:parser_combinator/src/parser/base/action/piped.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

Parser<R> _where<R>(
  Parser<R> parser,
  WhereParserFunction<R> predicate, {
  String? message = "Where predicate failure.",
  String Function(R)? messageBuilder,
}) {
  return parser.pipe(toString: () => "WhereParser", (_, context) {
    if (context is Success<R>) {
      if (predicate(context.value)) {
        return context;
      } else {
        return context.failure(messageBuilder?.call(context.value) ?? message);
      }
    }
    return context;
  });
}

extension WhereParser<R> on Parser<R> {
  Parser<R> where(
    WhereParserFunction<R> function, {
    String? message = "Where predicate failure.",
    String Function(R)? messageBuilder,
  }) =>
      _where(this, function, message: message, messageBuilder: messageBuilder);
}
