
part of "action.dart";

///
/// A [ParserAction] that executes a `continue` action.
///
class ContinueAction<R> implements ParserAction {
  final Context<R> result;
  final Continuation<R> continuation;

  const ContinueAction(this.result, this.continuation);

  @override
  void call(Trampoline trampoline) {
    continuation(result);
  }
}
