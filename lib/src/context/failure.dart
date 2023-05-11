part of "context.dart";

@optionalTypeArgs
@immutable
class Failure extends Context<Never> {
  @override
  Never get value => throw UnsupportedError("`Failure` does not have a result!");

  @override
  Never get cst => throw UnsupportedError("`Failure` does not have an cst!");

  @override
  final String message;
  final bool artificial;

  const Failure(this.message, [super.input = "", super.index = 0, super.indentation = const <int>[0]]) //
      : artificial = false;
  const Failure.artificial(this.message, [super.input = "", super.index = 0, super.indentation = const <int>[0]])
      : artificial = true;

  @override
  Never unwrap() => throw Exception(generateFailureMessage());

  @override
  Null tryUnwrap() => null;

  @override
  Failure replaceIndex(int index) => Failure(message, input, index, indentation);

  @override
  Failure replaceInput(String input) => Failure(message, input, index, indentation);

  @override
  Failure inherit<I>(Context<I> context) => Failure(message, context.input, context.index, context.indentation);

  @override
  Failure pushIndent(int indent) => Failure(message, input, index, <int>[indent, ...indentation]);

  @override
  Failure popIndent() => Failure(message, input, index, indentation.sublist(1));

  @override
  String toString() => "Failure($location): $message";

  String get padded => input.split("\n").map((String c) => "$c ").join("\n");

  static String _highlightIndent(String input) {
    int i = input.length - input.trimLeft().length;

    return "${"·" * i}${input.substring(i)}";
  }

  /// Takes a line and shortens it as necessary. Returns a list of three strings, would really appreciate
  /// using the Record type proposal here.
  static (String, String, String) _shortenLine(int threshold, String line, int pointer) {
    String cleanedLine = _highlightIndent(line);

    if (pointer < 0) {
      return ("", "·", line);
    }
    if (pointer > cleanedLine.length) {
      return (line, ".", "");
    }

    String before = cleanedLine.substring(0, pointer);
    String at = cleanedLine[pointer];
    String after = cleanedLine.substring(pointer + 1);

    String shortenedBefore = before.length >= threshold //
        ? "...${before.substring(before.length - threshold)}"
        : before;
    String now = at.trim().isEmpty ? "·" : at;
    String shortenedAfter = after.length >= threshold //
        ? "${after.substring(0, threshold)}..."
        : after;

    return (shortenedBefore, now, shortenedAfter);
  }

  String get failureMessage => generateFailureMessage();

  String generateFailureMessage() {
    const int threshold = 12;
    const String lineIndent = "  ";

    var (String left, String point, String right) = _shortenLine(threshold, padded.split("\n")[line - 1], column - 1);

    String specificLine = "$lineIndent$left$point$right";
    String cursorBuffer = " " * left.length;

    String displayLineNumber = "$line";
    String barBuffer = " " * displayLineNumber.length;
    String noNumberBar = "$barBuffer |";
    String numberedBar = "$displayLineNumber |";

    String full = """
$message
$barBuffer--> ($line, $column)
$noNumberBar
$numberedBar$specificLine
$noNumberBar$cursorBuffer  ^
$noNumberBar
    """;

    return full;
  }
}

// ignore: avoid_positional_boolean_parameters
extension FailureExtension on Failure Function([String? message, bool artificial]) {
  Failure artificial([String? message]) => this(message, true);
}
