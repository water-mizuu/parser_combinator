import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/action/piped.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/shared/typedef.dart";

Parser<R> _where<R>(
  Parser<R> parser,
  WhereParserFunction<R> predicate, {
  String? message,
  String Function(R)? messageBuilder,
}) {
  message ??= "Where predicate failure.";

  return parser.pipe(toString: () => "WhereParser", (_, Context<R> context) {
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
    String? message,
    String Function(R)? messageBuilder,
  }) =>
      _where(this, function, message: message, messageBuilder: messageBuilder);
}
