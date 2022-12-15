import "package:parser_combinator/parser_combinator.dart";

String _generateAsciiTree(
  Expando<bool> built,
  Map<Parser, int> rules,
  Parser parser,
  String indent, {
  required bool isLast,
  required int level,
}) {
  StringBuffer buffer = StringBuffer();
  String marker = isLast ? "└─" : "├─";

  buffer
    ..write(indent)
    ..write(marker)
    ..write(" ");

  if (level > 0 && rules.containsKey(parser)) {
    buffer
      ..write("rule-${rules[parser]}")
      ..writeln();
  } else if (built[parser] != null) {
    buffer.writeln("...");
  } else {
    buffer.writeln("$parser");

    built[parser] = true;

    List<Parser> children = parser.children.toList();
    String newIndent = "$indent${isLast ? "   " : "│  "}";
    for (int i = 0; i < children.length; ++i) {
      String childrenTree = _generateAsciiTree(
        built,
        rules,
        children[i],
        newIndent,
        isLast: i == children.length - 1,
        level: level + 1,
      );
      buffer.write(childrenTree);
    }
    built[parser] = null;
  }

  return buffer.toString();
}

extension AsciiTreeParserExtension<R> on Parser<R> {
  String generateAsciiTree() {
    int i = 0;
    Map<Parser, int> rules = {for (Parser p in this.rules()) p: ++i};
    Expando<bool> expando = Expando();
    StringBuffer buffer = StringBuffer();

    for (Parser p in rules.keys) {
      buffer
        ..writeln("rule-${rules[p]}")
        ..writeln(_generateAsciiTree(expando, rules, p, "", isLast: true, level: 0));
    }

    return buffer.toString().trim();
  }
}
