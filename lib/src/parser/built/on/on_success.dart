// ignore_for_file: unnecessary_cast

import "package:parser_combinator/parser_combinator.dart";

Parser<O> _onSuccess<R, O>(Parser<R> parser, O value) {
  return parser.pipe(
    (_, Context<R> result) => switch (result) {
      Context<Never> result => result as Context<O>,
      Context<R> context => context.success(value),
    },
    toString: () => "OnSuccessParser",
  );
}

extension OnSuccessParserExtension<R> on Parser<R> {
  Parser<O> onSuccess<O>(O value) => _onSuccess(this, value);
}
