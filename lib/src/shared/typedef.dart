import "package:parser_combinator/src/context/context.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";

typedef Lazy<T> = T Function();

typedef ParserBooleanCache = Expando<bool>;
typedef ParserCache = Expando<Parser<void>>;
typedef TransformFunction = Parser<R> Function<R>(Parser<R> target);

typedef PipedParserFunction<R, C> = Context<R> Function(Context<void> before, Context<C> after);
typedef BoundParserFunction<R, C> = Parser<R> Function(List<Parser<void>> children, Context<C> result);
typedef MappedParserFunction<R, C> = R Function(C value);
typedef WhereParserFunction<C> = bool Function(C value);
typedef ThenParserFunction<C> = void Function(C value);
typedef ExpandedParserFunction<R, C> = Context<R> Function(C value);
typedef ContextPredicateFunction<R> = Context<R> Function(Context<void> context);
