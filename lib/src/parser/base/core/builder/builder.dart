import "package:meta/meta.dart";
import "package:parser_combinator/src/extension/build.dart";
import "package:parser_combinator/src/extension/replace.dart";
import "package:parser_combinator/src/parser/base/combinator/choice.dart";
import "package:parser_combinator/src/parser/base/combinator/sequence.dart";
import "package:parser_combinator/src/parser/base/core/abstract/parser.dart";
import "package:parser_combinator/src/parser/built/action/map.dart";
import "package:parser_combinator/src/parser/built/cycle/cycle_star.dart";
import "package:parser_combinator/src/parser/built/predicate/failure.dart";
import "package:parser_combinator/src/parser/built/special/blank.dart";
import "package:parser_combinator/src/shared/util.dart";

typedef AtomicHandler<Result, Value> = Result Function(Value value);
typedef PrefixHandler<Result, Operator, Value> = Result Function(Operator operator, Value value);
typedef PostfixHandler<Result, Value, Operator> = Result Function(Value value, Operator operator);
typedef SurroundHandler<Result, Left, Value, Right> = Result Function(Left left, Value value, Right right);
typedef InfixHandler<Result, Left, Operator, Right> = Result Function(Left left, Operator operator, Right right);

typedef MonoidInfixHandler<Result, Operator> = InfixHandler<Result, Result, Operator, Result>;
typedef MonoidPrefixHandler<Result, Operator> = PrefixHandler<Result, Operator, Result>;
typedef MonoidPostfixHandler<Result, Operator> = PostfixHandler<Result, Result, Operator>;
typedef MonoidSurroundHandler<O, Left, Right> = SurroundHandler<O, Left, O, Right>;

extension<R extends Object> on R {
  O _pipe<O>(O Function(R) function) => function(this);
}

class ExpressionBuilder<T> {
  final List<ExpressionGroup<T>> expressionGroups = <ExpressionGroup<T>>[];
  final Parser<T> mirror = blank();

  ExpressionGroup<T> get group => ExpressionGroup<T>(mirror, this);

  Parser<T> build() {
    if (expressionGroups.isEmpty) {
      throw UnsupportedError("An empty builder cannot be built!");
    }
    Parser<T> minimum = failure<T>("An expression builder should define an atomic parser.");
    Parser<T> built = expressionGroups.fold(minimum, (a, group) => group.build(a)..pegMemoize = true);
    built.replace(mirror, built);

    return built.build();
  }
}

@optionalTypeArgs
class ExpressionGroup<T> {
  final Parser<T> mirror;

  ExpressionGroup(this.mirror, ExpressionBuilder<T> parent) {
    parent.expressionGroups.add(this);
  }

  List<Parser<T>> _surround = [];
  Parser<T> _buildSurround(Parser<T> previous) => (_surround.isEmpty ? previous : _surround.choice()) / previous;

  ExpressionGroup<T> surround<L extends Object, R extends Object>(
    Parser<L> left,
    Parser<R> right,
    MonoidSurroundHandler<T, L, R> handler,
  ) =>
      this.._surround.add((left & mirror & right).map((v) => handler(v[0].cast(), v[1].cast(), v[2].cast())));

  List<Parser<InfixWrapper<T, void>>> _left = [];
  Parser<T> _buildLeft(Parser<T> previous) => _left.isEmpty
      ? previous
      : (previous & (_left.choice() & previous).star()).map(($) {
          T head = $[0].cast<T>();
          List<Object?> tail = $[1].cast<List<List<Object?>>>().expand((v) => v).toList();
          List<Object?> flattened = <Object?>[head, ...tail];

          T left = head;
          for (int i = 1; i < flattened.length - 1; i += 2) {
            InfixWrapper<T, void> handler = flattened[i].cast<InfixWrapper<T, void>>();
            T right = flattened[i + 1].cast<T>();

            left = handler.evaluate(left, right);
          }
          return left;
        });

  ExpressionGroup<T> left<O>(Parser<O> operator, MonoidInfixHandler<T, O> handler) =>
      this.._left.add(operator.map((result) => InfixWrapper<T, O>(result, handler)));

  List<Parser<InfixWrapper<T, void>>> _right = [];
  Parser<T> _buildRight(Parser<T> previous) => _right.isEmpty
      ? previous
      : (previous & (_right.choice() & previous).star()).map(($) {
          T head = $[0].cast<T>();
          List<Object?> tail = $[1].cast<List<List<Object?>>>().expand((v) => v).toList();
          List<Object?> flattened = <Object?>[head, ...tail];

          T right = flattened.last as T;
          for (int i = flattened.length - 1; i >= 1; i -= 2) {
            InfixWrapper<T, void> handler = flattened[i - 1].cast<InfixWrapper<T, void>>();
            T left = flattened[i - 2].cast<T>();

            right = handler.evaluate(left, right);
          }

          return right;
        });

  ExpressionGroup<T> right<O>(Parser<O> operator, MonoidInfixHandler<T, O> handler) =>
      this.._right.add(operator.map((result) => InfixWrapper<T, O>(result, handler)));

  List<Parser<T>> _atomic = [];
  Parser<T> _buildAtomic(Parser<T> previous) => (_atomic.isEmpty ? previous : previous) / _atomic.choice();
  ExpressionGroup<T> atomic<O>(Parser<O> parser, AtomicHandler<T, O> mapper) => this.._atomic.add(parser.map(mapper));

  List<Parser<PrefixWrapper<T, void>>> _pre = [];
  Parser<T> _buildPre(Parser<T> previous) => _pre.isEmpty
      ? previous
      : (_pre.choice().star() & previous).map(($) {
          var [wrapper as List<PrefixWrapper<T, void>>, result as T] = $;
          for (int i = wrapper.length - 1; i >= 0; i--) {
            result = wrapper[i].evaluate(result);
          }
          return result;
        });
  ExpressionGroup<T> pre<O>(Parser<O> parser, MonoidPrefixHandler<T, O> handler) =>
      this.._pre.add(parser.map((op) => PrefixWrapper<T, O>(op, handler)));

  final List<Parser<PostfixWrapper<T, void>>> _post = [];
  Parser<T> _buildPost(Parser<T> previous) => _post.isEmpty
      ? previous
      : (previous & _post.choice().star()).map(($) {
          var [result as T, wrapper as List<PostfixWrapper<T, void>>] = $;
          for (int i = 0; i < wrapper.length; ++i) {
            result = wrapper[i].evaluate(result);
          }
          return result;
        });
  ExpressionGroup<T> post<O>(Parser<O> parser, MonoidPostfixHandler<T, O> handler) =>
      this.._post.add(parser.map((op) => PostfixWrapper<T, O>(op, handler)));

  Parser<T> build(Parser<T> previous) => previous
      ._pipe(_buildAtomic)
      ._pipe(_buildLeft)
      ._pipe(_buildRight)
      ._pipe(_buildSurround)
      ._pipe(_buildPre)
      ._pipe(_buildPost);
}

@optionalTypeArgs
class InfixWrapper<R, O> {
  final O operator;
  final MonoidInfixHandler<R, O> handler;

  const InfixWrapper(this.operator, this.handler);

  R evaluate(R left, R right) => handler(left, operator, right);
}

@optionalTypeArgs
class PrefixWrapper<R, O> {
  final O operator;
  final MonoidPrefixHandler<R, O> handler;

  const PrefixWrapper(this.operator, this.handler);

  R evaluate(R value) => handler(operator, value);
}

@optionalTypeArgs
class PostfixWrapper<R, O> {
  final O operator;
  final MonoidPostfixHandler<R, O> handler;

  const PostfixWrapper(this.operator, this.handler);

  R evaluate(R value) => handler(value, operator);
}
