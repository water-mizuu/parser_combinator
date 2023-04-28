part of "grammar.dart";

class _AsciiMathConversion implements Comparable<_AsciiMathConversion> {
  final String asciimath;
  final bool rawFirst;
  final bool firstIsOption;
  final String? tex;
  final (String, String)? rewriteLeftRight;

  const _AsciiMathConversion({
    required this.asciimath,
    this.tex,
    this.firstIsOption = false,
    this.rawFirst = false,
    this.rewriteLeftRight,
  });

  @override
  int compareTo(_AsciiMathConversion other) => other.asciimath.length - asciimath.length;
}

mixin _AsciiMathDefinitions {
  List<_AsciiMathConversion> get greekLetters => const [
        _AsciiMathConversion(asciimath: "alpha", tex: r"\alpha"),
        _AsciiMathConversion(asciimath: "beta", tex: r"\beta"),
        _AsciiMathConversion(asciimath: "gamma", tex: r"\gamma"),
        _AsciiMathConversion(asciimath: "Gamma", tex: r"\Gamma"),
        _AsciiMathConversion(asciimath: "delta", tex: r"\delta"),
        _AsciiMathConversion(asciimath: "Delta", tex: r"\Delta"),
        _AsciiMathConversion(asciimath: "epsilon", tex: r"\epsilon"),
        _AsciiMathConversion(asciimath: "varepsilon", tex: r"\varepsilon"),
        _AsciiMathConversion(asciimath: "zeta", tex: r"\zeta"),
        _AsciiMathConversion(asciimath: "eta", tex: r"\eta"),
        _AsciiMathConversion(asciimath: "theta", tex: r"\theta"),
        _AsciiMathConversion(asciimath: "Theta", tex: r"\Theta"),
        _AsciiMathConversion(asciimath: "vartheta", tex: r"\vartheta"),
        _AsciiMathConversion(asciimath: "iota", tex: r"\iota"),
        _AsciiMathConversion(asciimath: "kappa", tex: r"\kappa"),
        _AsciiMathConversion(asciimath: "lambda", tex: r"\lambda"),
        _AsciiMathConversion(asciimath: "Lambda", tex: r"\Lambda"),
        _AsciiMathConversion(asciimath: "mu", tex: r"\mu"),
        _AsciiMathConversion(asciimath: "nu", tex: r"\nu"),
        _AsciiMathConversion(asciimath: "xi", tex: r"\xi"),
        _AsciiMathConversion(asciimath: "Xi", tex: r"\Xi"),
        _AsciiMathConversion(asciimath: "pi", tex: r"\pi"),
        _AsciiMathConversion(asciimath: "Pi", tex: r"\Pi"),
        _AsciiMathConversion(asciimath: "rho", tex: r"\rho"),
        _AsciiMathConversion(asciimath: "sigma", tex: r"\sigma"),
        _AsciiMathConversion(asciimath: "Sigma", tex: r"\Sigma"),
        _AsciiMathConversion(asciimath: "tau", tex: r"\tau"),
        _AsciiMathConversion(asciimath: "upsilon", tex: r"\upsilon"),
        _AsciiMathConversion(asciimath: "phi", tex: r"\phi"),
        _AsciiMathConversion(asciimath: "Phi", tex: r"\Phi"),
        _AsciiMathConversion(asciimath: "varphi", tex: r"\varphi"),
        _AsciiMathConversion(asciimath: "chi", tex: r"\chi"),
        _AsciiMathConversion(asciimath: "psi", tex: r"\psi"),
        _AsciiMathConversion(asciimath: "Psi", tex: r"\Psi"),
        _AsciiMathConversion(asciimath: "omega", tex: r"\omega"),
        _AsciiMathConversion(asciimath: "Omega", tex: r"\Omega"),
      ];

  List<_AsciiMathConversion> get arithmeticSymbols => const [
        _AsciiMathConversion(asciimath: "+", tex: "+"),
        _AsciiMathConversion(asciimath: "*", tex: "*"),
        _AsciiMathConversion(asciimath: "//", tex: "/"),
        _AsciiMathConversion(asciimath: "&", tex: "&"),
        _AsciiMathConversion(asciimath: "'", tex: "'"),
        _AsciiMathConversion(asciimath: "::", tex: "::"),
        _AsciiMathConversion(asciimath: ",", tex: ","),
        _AsciiMathConversion(asciimath: "°", tex: r"^\circ"),
      ];

  List<_AsciiMathConversion> get relationSymbols => const [
        _AsciiMathConversion(asciimath: "&=", tex: "&="),
        _AsciiMathConversion(asciimath: "=", tex: "="),
        _AsciiMathConversion(asciimath: ":=", tex: ":="),
        _AsciiMathConversion(asciimath: ":|:", tex: r"\|"),
        _AsciiMathConversion(asciimath: "=>", tex: r"\Rightarrow"),
        _AsciiMathConversion(asciimath: "approx", tex: r"\approx"),
        _AsciiMathConversion(asciimath: "~~", tex: r"\approx"),
        _AsciiMathConversion(asciimath: "cong", tex: r"\cong"),
        _AsciiMathConversion(asciimath: "~=", tex: r"\cong"),
        _AsciiMathConversion(asciimath: "equiv", tex: r"\equiv"),
        _AsciiMathConversion(asciimath: "-=", tex: r"\equiv"),
        _AsciiMathConversion(asciimath: "exists", tex: r"\exists"),
        _AsciiMathConversion(asciimath: "EE", tex: r"\exists"),
        _AsciiMathConversion(asciimath: "forall", tex: r"\forall"),
        _AsciiMathConversion(asciimath: "AA", tex: r"\forall"),
        _AsciiMathConversion(asciimath: ">=", tex: r"\ge"),
        _AsciiMathConversion(asciimath: "ge", tex: r"\ge"),
        _AsciiMathConversion(asciimath: "gt=", tex: r"\geq"),
        _AsciiMathConversion(asciimath: "geq", tex: r"\geq"),
        _AsciiMathConversion(asciimath: ">", tex: r"\gt"),
        _AsciiMathConversion(asciimath: "gt", tex: r"\gt"),
        _AsciiMathConversion(asciimath: "in", tex: r"\in"),
        _AsciiMathConversion(asciimath: "<=", tex: r"\le"),
        _AsciiMathConversion(asciimath: "le", tex: r"\le"),
        _AsciiMathConversion(asciimath: "lt=", tex: r"\leq"),
        _AsciiMathConversion(asciimath: "leq", tex: r"\leq"),
        _AsciiMathConversion(asciimath: "<", tex: r"\lt"),
        _AsciiMathConversion(asciimath: "lt", tex: r"\lt"),
        _AsciiMathConversion(asciimath: "models", tex: r"\models"),
        _AsciiMathConversion(asciimath: "|==", tex: r"\models"),
        _AsciiMathConversion(asciimath: "!=", tex: r"\ne"),
        _AsciiMathConversion(asciimath: "ne", tex: r"\ne"),
        _AsciiMathConversion(asciimath: "notin", tex: r"\notin"),
        _AsciiMathConversion(asciimath: "!in", tex: r"\notin"),
        _AsciiMathConversion(asciimath: "prec", tex: r"\prec"),
        _AsciiMathConversion(asciimath: "-lt", tex: r"\prec"),
        _AsciiMathConversion(asciimath: "-<", tex: r"\prec"),
        _AsciiMathConversion(asciimath: "preceq", tex: r"\preceq"),
        _AsciiMathConversion(asciimath: "-<=", tex: r"\preceq"),
        _AsciiMathConversion(asciimath: "propto", tex: r"\propto"),
        _AsciiMathConversion(asciimath: "prop", tex: r"\propto"),
        _AsciiMathConversion(asciimath: "subset", tex: r"\subset"),
        _AsciiMathConversion(asciimath: "sub", tex: r"\subset"),
        _AsciiMathConversion(asciimath: "subseteq", tex: r"\subseteq"),
        _AsciiMathConversion(asciimath: "sube", tex: r"\subseteq"),
        _AsciiMathConversion(asciimath: "succ", tex: r"\succ"),
        _AsciiMathConversion(asciimath: ">-", tex: r"\succ"),
        _AsciiMathConversion(asciimath: "succeq", tex: r"\succeq"),
        _AsciiMathConversion(asciimath: ">-=", tex: r"\succeq"),
        _AsciiMathConversion(asciimath: "supset", tex: r"\supset"),
        _AsciiMathConversion(asciimath: "sup", tex: r"\supset"),
        _AsciiMathConversion(asciimath: "supseteq", tex: r"\supseteq"),
        _AsciiMathConversion(asciimath: "supe", tex: r"\supseteq"),
        _AsciiMathConversion(asciimath: "vdash", tex: r"\vdash"),
        _AsciiMathConversion(asciimath: "|--", tex: r"\vdash"),
      ];

  List<_AsciiMathConversion> get leftBracketSymbols => const [
        _AsciiMathConversion(asciimath: "langle", tex: r"\langle"),
        _AsciiMathConversion(asciimath: "lbrace", tex: r"\lbrace"),
        _AsciiMathConversion(asciimath: "(:", tex: r"\langle"),
        _AsciiMathConversion(asciimath: "<<", tex: r"\langle"),
        _AsciiMathConversion(asciimath: "{:", tex: "."),
        _AsciiMathConversion(asciimath: "(", tex: "("),
        _AsciiMathConversion(asciimath: "[", tex: "["),
        _AsciiMathConversion(asciimath: "⌊", tex: "⌊"),
        _AsciiMathConversion(asciimath: "{", tex: r"\lbrace"),
        _AsciiMathConversion(asciimath: "||", tex: r"\|"),
        // AsciiMathConversion(asciimath: "|", tex: "|"),
      ];

  List<_AsciiMathConversion> get rightBracketSymbols => const [
        _AsciiMathConversion(asciimath: "rangle", tex: r"\rangle"),
        _AsciiMathConversion(asciimath: "rbrace", tex: r"\rbrace"),
        _AsciiMathConversion(asciimath: ":)", tex: r"\rangle"),
        _AsciiMathConversion(asciimath: ">>", tex: r"\rangle"),
        _AsciiMathConversion(asciimath: ":}", tex: "."),
        _AsciiMathConversion(asciimath: ")", tex: ")"),
        _AsciiMathConversion(asciimath: "]", tex: "]"),
        _AsciiMathConversion(asciimath: "}", tex: r"\rbrace"),
        _AsciiMathConversion(asciimath: "||", tex: r"\|"),
        // AsciiMathConversion(asciimath: "|", tex: "|"),
      ];

  List<_AsciiMathConversion> get constantSymbols => const [
        _AsciiMathConversion(asciimath: "sin", tex: r"\sin"),
        _AsciiMathConversion(asciimath: "cos", tex: r"\cos"),
        _AsciiMathConversion(asciimath: "tan", tex: r"\tan"),
        _AsciiMathConversion(asciimath: "arcsin", tex: r"\arcsin"),
        _AsciiMathConversion(asciimath: "arccos", tex: r"\arccos"),
        _AsciiMathConversion(asciimath: "arctan", tex: r"\arctan"),
        _AsciiMathConversion(asciimath: "sinh", tex: r"\sinh"),
        _AsciiMathConversion(asciimath: "cosh", tex: r"\cosh"),
        _AsciiMathConversion(asciimath: "tanh", tex: r"\tanh"),
        _AsciiMathConversion(asciimath: "cot", tex: r"\cot"),
        _AsciiMathConversion(asciimath: "coth", tex: r"\coth"),
        _AsciiMathConversion(asciimath: "sech", tex: r"\operatorname{sech}"),
        _AsciiMathConversion(asciimath: "csch", tex: r"\operatorname{csch}"),
        _AsciiMathConversion(asciimath: "sec", tex: r"\sec"),
        _AsciiMathConversion(asciimath: "csc", tex: r"\csc"),
        _AsciiMathConversion(asciimath: "log", tex: r"\log"),
        _AsciiMathConversion(asciimath: "ln", tex: r"\ln"),
        _AsciiMathConversion(asciimath: "deg", tex: "°"),
        _AsciiMathConversion(asciimath: "da", tex: "da"),
        _AsciiMathConversion(asciimath: "db", tex: "db"),
        _AsciiMathConversion(asciimath: "dc", tex: "dc"),
        _AsciiMathConversion(asciimath: "dd", tex: "dd"),
        _AsciiMathConversion(asciimath: "de", tex: "de"),
        _AsciiMathConversion(asciimath: "df", tex: "df"),
        _AsciiMathConversion(asciimath: "dg", tex: "dg"),
        _AsciiMathConversion(asciimath: "dh", tex: "dh"),
        _AsciiMathConversion(asciimath: "di", tex: "di"),
        _AsciiMathConversion(asciimath: "dj", tex: "dj"),
        _AsciiMathConversion(asciimath: "dk", tex: "dk"),
        _AsciiMathConversion(asciimath: "dl", tex: "dl"),
        _AsciiMathConversion(asciimath: "dm", tex: "dm"),
        _AsciiMathConversion(asciimath: "dn", tex: "dn"),
        _AsciiMathConversion(asciimath: "do", tex: "do"),
        _AsciiMathConversion(asciimath: "dp", tex: "dp"),
        _AsciiMathConversion(asciimath: "dq", tex: "dq"),
        _AsciiMathConversion(asciimath: "dr", tex: "dr"),
        _AsciiMathConversion(asciimath: "ds", tex: "ds"),
        _AsciiMathConversion(asciimath: "dt", tex: "dt"),
        _AsciiMathConversion(asciimath: "du", tex: "du"),
        _AsciiMathConversion(asciimath: "dv", tex: "dv"),
        _AsciiMathConversion(asciimath: "dw", tex: "dw"),
        _AsciiMathConversion(asciimath: "dx", tex: "dx"),
        _AsciiMathConversion(asciimath: "dy", tex: "dy"),
        _AsciiMathConversion(asciimath: "dz", tex: "dz"),
        _AsciiMathConversion(asciimath: "prime", tex: "'"),
        _AsciiMathConversion(asciimath: "implies", tex: r"\implies"),
        _AsciiMathConversion(asciimath: "ell", tex: r"\ell"),
        _AsciiMathConversion(asciimath: "epsi", tex: r"\epsilon"),
        _AsciiMathConversion(asciimath: "leftrightarrow", tex: r"\leftrightarrow"),
        _AsciiMathConversion(asciimath: "Leftrightarrow", tex: r"\Leftrightarrow"),
        _AsciiMathConversion(asciimath: "rightarrow", tex: r"\rightarrow"),
        _AsciiMathConversion(asciimath: "Rightarrow", tex: r"\Rightarrow"),
        _AsciiMathConversion(asciimath: "backslash", tex: r"\backslash"),
        _AsciiMathConversion(asciimath: "leftarrow", tex: r"\leftarrow"),
        _AsciiMathConversion(asciimath: "Leftarrow", tex: r"\Leftarrow"),
        _AsciiMathConversion(asciimath: "setminus", tex: r"\setminus"),
        _AsciiMathConversion(asciimath: "bigwedge", tex: r"\bigwedge"),
        _AsciiMathConversion(asciimath: "diamond", tex: r"\diamond"),
        _AsciiMathConversion(asciimath: "bowtie", tex: r"\bowtie"),
        _AsciiMathConversion(asciimath: "bigvee", tex: r"\bigvee"),
        _AsciiMathConversion(asciimath: "bigcap", tex: r"\bigcap"),
        _AsciiMathConversion(asciimath: "bigcup", tex: r"\bigcup"),
        _AsciiMathConversion(asciimath: "square", tex: r"\square"),
        _AsciiMathConversion(asciimath: "lamda", tex: r"\lambda"),
        _AsciiMathConversion(asciimath: "Lamda", tex: r"\Lambda"),
        _AsciiMathConversion(asciimath: "aleph", tex: r"\aleph"),
        _AsciiMathConversion(asciimath: "angle", tex: r"\angle"),
        _AsciiMathConversion(asciimath: "frown", tex: r"\frown"),
        _AsciiMathConversion(asciimath: "limits", tex: r"\limits"),
        _AsciiMathConversion(asciimath: "qquad", tex: r"\qquad"),
        _AsciiMathConversion(asciimath: "cdots", tex: r"\cdots"),
        _AsciiMathConversion(asciimath: "vdots", tex: r"\vdots"),
        _AsciiMathConversion(asciimath: "ddots", tex: r"\ddots"),
        _AsciiMathConversion(asciimath: "cdot", tex: r"\cdot"),
        _AsciiMathConversion(asciimath: "star", tex: r"\star"),
        _AsciiMathConversion(asciimath: "|><|", tex: r"\bowtie"),
        _AsciiMathConversion(asciimath: "circ", tex: r"\circ"),
        _AsciiMathConversion(asciimath: "int", tex: r"\int"),
        _AsciiMathConversion(asciimath: "oint", tex: r"\oint"),
        _AsciiMathConversion(asciimath: "ointlim", tex: r"\oint\limits"),
        _AsciiMathConversion(asciimath: "grad", tex: r"\nabla"),
        _AsciiMathConversion(asciimath: "quad", tex: r"\quad"),
        _AsciiMathConversion(asciimath: "uarr", tex: r"\uparrow"),
        _AsciiMathConversion(asciimath: "darr", tex: r"\downarrow"),
        _AsciiMathConversion(asciimath: "downarrow", tex: r"\downarrow"),
        _AsciiMathConversion(asciimath: "rarr", tex: r"\rightarrow"),
        _AsciiMathConversion(asciimath: ">->>", tex: r"\twoheadrightarrowtail"),
        _AsciiMathConversion(asciimath: "larr", tex: r"\leftarrow"),
        _AsciiMathConversion(asciimath: "harr", tex: r"\leftrightarrow"),
        _AsciiMathConversion(asciimath: "rArr", tex: r"\Rightarrow"),
        _AsciiMathConversion(asciimath: "lArr", tex: r"\Leftarrow"),
        _AsciiMathConversion(asciimath: "hArr", tex: r"\Leftrightarrow"),
        _AsciiMathConversion(asciimath: "ast", tex: r"\ast"),
        _AsciiMathConversion(asciimath: "***", tex: r"\star"),
        _AsciiMathConversion(asciimath: "|><", tex: r"\ltimes"),
        _AsciiMathConversion(asciimath: "><|", tex: r"\rtimes"),
        _AsciiMathConversion(asciimath: "^^^", tex: r"\bigwedge"),
        _AsciiMathConversion(asciimath: "vvv", tex: r"\bigvee"),
        _AsciiMathConversion(asciimath: "cap", tex: r"\cap"),
        _AsciiMathConversion(asciimath: "nnn", tex: r"\bigcap"),
        _AsciiMathConversion(asciimath: "cup", tex: r"\cup"),
        _AsciiMathConversion(asciimath: "uuu", tex: r"\bigcup"),
        _AsciiMathConversion(asciimath: "not", tex: r"\neg"),
        _AsciiMathConversion(asciimath: "<=>", tex: r"\Leftrightarrow"),
        _AsciiMathConversion(asciimath: "_|_", tex: r"\bot"),
        _AsciiMathConversion(asciimath: "bot", tex: r"\bot"),
        _AsciiMathConversion(asciimath: "int", tex: r"\int"),
        _AsciiMathConversion(asciimath: "intlim", tex: r"\int\limits"),
        _AsciiMathConversion(asciimath: "del", tex: r"\partial"),
        _AsciiMathConversion(asciimath: "...", tex: r"\ldots"),
        _AsciiMathConversion(asciimath: r"/_\", tex: r"\triangle"),
        _AsciiMathConversion(asciimath: "|__", tex: r"\lfloor"),
        _AsciiMathConversion(asciimath: "__|", tex: r"\rfloor"),
        _AsciiMathConversion(asciimath: "dim", tex: r"\dim"),
        _AsciiMathConversion(asciimath: "mod", tex: r"\operatorname{mod}"),
        _AsciiMathConversion(asciimath: "lub", tex: r"\operatorname{lub}"),
        _AsciiMathConversion(asciimath: "glb", tex: r"\operatorname{glb}"),
        _AsciiMathConversion(asciimath: ">->", tex: r"\rightarrowtail"),
        _AsciiMathConversion(asciimath: "->>", tex: r"\twoheadrightarrow"),
        _AsciiMathConversion(asciimath: "|->", tex: r"\mapsto"),
        _AsciiMathConversion(asciimath: "lim", tex: r"\lim\limits"),
        _AsciiMathConversion(asciimath: "Lim", tex: r"\operatorname{Lim}"),
        _AsciiMathConversion(asciimath: "and", tex: r"\quad\text{and}\quad"),
        _AsciiMathConversion(asciimath: "**", tex: r"\ast"),
        _AsciiMathConversion(asciimath: "//", tex: "/"),
        _AsciiMathConversion(asciimath: r"\", tex: r"\,"),
        _AsciiMathConversion(asciimath: r"\\", tex: r"\backslash"),
        _AsciiMathConversion(asciimath: "xx", tex: r"\times"),
        _AsciiMathConversion(asciimath: "-:", tex: r"\div"),
        _AsciiMathConversion(asciimath: "o+", tex: r"\oplus"),
        _AsciiMathConversion(asciimath: "ox", tex: r"\otimes"),
        _AsciiMathConversion(asciimath: "o.", tex: r"\odot"),
        _AsciiMathConversion(asciimath: "^^", tex: r"\wedge"),
        _AsciiMathConversion(asciimath: "vv", tex: r"\vee"),
        _AsciiMathConversion(asciimath: "nn", tex: r"\cap"),
        _AsciiMathConversion(asciimath: "uu", tex: r"\cup"),
        _AsciiMathConversion(asciimath: "TT", tex: r"\top"),
        _AsciiMathConversion(asciimath: "+-", tex: r"\pm"),
        _AsciiMathConversion(asciimath: "-+", tex: r"\mp"),
        _AsciiMathConversion(asciimath: "O/", tex: r"\emptyset"),
        _AsciiMathConversion(asciimath: "oo", tex: r"\infty"),
        _AsciiMathConversion(asciimath: ":.", tex: r"\therefore"),
        _AsciiMathConversion(asciimath: ":'", tex: r"\because"),
        _AsciiMathConversion(asciimath: "/_", tex: r"\angle"),
        _AsciiMathConversion(asciimath: "|~", tex: r"\lceil"),
        _AsciiMathConversion(asciimath: "~|", tex: r"\rceil"),
        _AsciiMathConversion(asciimath: "RR", tex: r"\mathbb{R}"),
        _AsciiMathConversion(asciimath: "cc", tex: r"\mathbf{C}"),
        _AsciiMathConversion(asciimath: "CC", tex: r"\mathbb{C}"),
        _AsciiMathConversion(asciimath: "NN", tex: r"\mathbb{N}"),
        _AsciiMathConversion(asciimath: "ZZ", tex: r"\mathbb{Z}"),
        _AsciiMathConversion(asciimath: "QQ", tex: r"\mathbb{Q}"),
        _AsciiMathConversion(asciimath: "II", tex: r"\mathbb{I}"),
        _AsciiMathConversion(asciimath: "real", tex: r"\mathbb{R}"),
        _AsciiMathConversion(asciimath: "complex", tex: r"\mathbb{C}"),
        _AsciiMathConversion(asciimath: "natural", tex: r"\mathbb{N}"),
        _AsciiMathConversion(asciimath: "integer", tex: r"\mathbb{Z}"),
        _AsciiMathConversion(asciimath: "rational", tex: r"\mathbb{Q}"),
        _AsciiMathConversion(asciimath: "imaginary", tex: r"\mathbb{I}"),
        _AsciiMathConversion(asciimath: "constant", tex: r"\mathbf{C}"),
        _AsciiMathConversion(asciimath: "->", tex: r"\to"),
        _AsciiMathConversion(asciimath: "or", tex: r"\quad\text{or}\quad"),
        _AsciiMathConversion(asciimath: "if", tex: r"\quad\text{if}\quad"),
        _AsciiMathConversion(asciimath: "iff", tex: r"\iff"),
        _AsciiMathConversion(asciimath: "*", tex: r"\cdot"),
        _AsciiMathConversion(asciimath: "@", tex: r"\circ"),
        _AsciiMathConversion(asciimath: "%", tex: r"\%"),
        _AsciiMathConversion(asciimath: "boxempty", tex: r"\square"),
        _AsciiMathConversion(asciimath: "lambda", tex: r"\lambda"),
        _AsciiMathConversion(asciimath: "Lambda", tex: r"\Lambda"),
        _AsciiMathConversion(asciimath: "nabla", tex: r"\nabla"),
        _AsciiMathConversion(asciimath: "uparrow", tex: r"\uparrow"),
        _AsciiMathConversion(asciimath: "downarrow", tex: r"\downarrow"),
        _AsciiMathConversion(asciimath: "twoheadrightarrowtail", tex: r"\twoheadrightarrowtail"),
        _AsciiMathConversion(asciimath: "ltimes", tex: r"\ltimes"),
        _AsciiMathConversion(asciimath: "rtimes", tex: r"\rtimes"),
        _AsciiMathConversion(asciimath: "neg", tex: r"\neg"),
        _AsciiMathConversion(asciimath: "partial", tex: r"\partial"),
        _AsciiMathConversion(asciimath: "ldots", tex: r"\ldots"),
        _AsciiMathConversion(asciimath: "triangle", tex: r"\triangle"),
        _AsciiMathConversion(asciimath: "lfloor", tex: r"\lfloor"),
        _AsciiMathConversion(asciimath: "rfloor", tex: r"\rfloor"),
        _AsciiMathConversion(asciimath: "rightarrowtail", tex: r"\rightarrowtail"),
        _AsciiMathConversion(asciimath: "twoheadrightarrow", tex: r"\twoheadrightarrow"),
        _AsciiMathConversion(asciimath: "mapsto", tex: r"\mapsto"),
        _AsciiMathConversion(asciimath: "times", tex: r"\times"),
        _AsciiMathConversion(asciimath: "div", tex: r"\div"),
        _AsciiMathConversion(asciimath: "divide", tex: r"\div"),
        _AsciiMathConversion(asciimath: "oplus", tex: r"\oplus"),
        _AsciiMathConversion(asciimath: "otimes", tex: r"\otimes"),
        _AsciiMathConversion(asciimath: "odot", tex: r"\odot"),
        _AsciiMathConversion(asciimath: "wedge", tex: r"\wedge"),
        _AsciiMathConversion(asciimath: "vee", tex: r"\vee"),
        _AsciiMathConversion(asciimath: "top", tex: r"\top"),
        _AsciiMathConversion(asciimath: "pm", tex: r"\pm"),
        _AsciiMathConversion(asciimath: "emptyset", tex: r"\emptyset"),
        _AsciiMathConversion(asciimath: "infty", tex: r"\infty"),
        _AsciiMathConversion(asciimath: "therefore", tex: r"\therefore"),
        _AsciiMathConversion(asciimath: "because", tex: r"\because"),
        _AsciiMathConversion(asciimath: "lceil", tex: r"\lceil"),
        _AsciiMathConversion(asciimath: "rceil", tex: r"\rceil"),
        _AsciiMathConversion(asciimath: "to", tex: r"\to"),
        _AsciiMathConversion(asciimath: "langle", tex: r"\langle"),
        _AsciiMathConversion(asciimath: "lceiling", tex: r"\lceil"),
        _AsciiMathConversion(asciimath: "rceiling", tex: r"\rceil"),
        _AsciiMathConversion(asciimath: "max", tex: r"\max"),
        _AsciiMathConversion(asciimath: "min", tex: r"\min"),
        _AsciiMathConversion(asciimath: "prod", tex: r"\prod\limits"),
        _AsciiMathConversion(asciimath: "sum", tex: r"\sum\limits"),
      ];

  List<_AsciiMathConversion> get unarySymbols => const [
        _AsciiMathConversion(asciimath: "text", tex: r"\text"),
        _AsciiMathConversion(asciimath: "ce", tex: r"\ce"),
        _AsciiMathConversion(asciimath: "sqrt", tex: r"\sqrt"),
        _AsciiMathConversion(asciimath: "boxed", tex: r"\boxed"),
        _AsciiMathConversion(asciimath: "abs", rewriteLeftRight: ("|", "|")),
        _AsciiMathConversion(asciimath: "norm", rewriteLeftRight: (r"\|", r"\|")),
        _AsciiMathConversion(asciimath: "floor", rewriteLeftRight: (r"\lfloor", r"\rfloor")),
        _AsciiMathConversion(asciimath: "ceil", rewriteLeftRight: (r"\lceil", r"\rceil")),
        _AsciiMathConversion(asciimath: "det", tex: r"\det"),
        _AsciiMathConversion(asciimath: "exp", tex: r"\exp"),
        _AsciiMathConversion(asciimath: "gcd", tex: r"\gcd"),
        _AsciiMathConversion(asciimath: "gcf", tex: r"\gcf"),
        _AsciiMathConversion(asciimath: "lcm", tex: r"\operatorname{lcm}"),
        _AsciiMathConversion(asciimath: "lcd", tex: r"\operatorname{lcd}"),
        _AsciiMathConversion(asciimath: "cancel", tex: r"\cancel"),
        _AsciiMathConversion(asciimath: "Sqrt", tex: r"\Sqrt"),
        _AsciiMathConversion(asciimath: "hat", tex: r"\hat"),
        _AsciiMathConversion(asciimath: "bar", tex: r"\overline"),
        _AsciiMathConversion(asciimath: "overline", tex: r"\overline"),
        _AsciiMathConversion(asciimath: "vec", tex: r"\vec"),
        _AsciiMathConversion(asciimath: "tilde", tex: r"\tilde"),
        _AsciiMathConversion(asciimath: "dot", tex: r"\dot"),
        _AsciiMathConversion(asciimath: "ddot", tex: r"\ddot"),
        _AsciiMathConversion(asciimath: "ul", tex: r"\underline"),
        _AsciiMathConversion(asciimath: "underline", tex: r"\underline"),
        _AsciiMathConversion(asciimath: "ubrace", tex: r"\underbrace"),
        _AsciiMathConversion(asciimath: "underbrace", tex: r"\underbrace"),
        _AsciiMathConversion(asciimath: "obrace", tex: r"\overbrace"),
        _AsciiMathConversion(asciimath: "overbrace", tex: r"\overbrace"),
        _AsciiMathConversion(asciimath: "bb", tex: r"\mathbf"),
        _AsciiMathConversion(asciimath: "mathbf", tex: "mathbf"),
        _AsciiMathConversion(asciimath: "sf", tex: r"\mathsf"),
        _AsciiMathConversion(asciimath: "mathsf", tex: "mathsf"),
        _AsciiMathConversion(asciimath: "bbb", tex: r"\mathbb"),
        _AsciiMathConversion(asciimath: "mathbb", tex: r"\mathbb"),
        _AsciiMathConversion(asciimath: "cc", tex: r"\mathcal"),
        _AsciiMathConversion(asciimath: "mathcal", tex: r"\mathcal"),
        _AsciiMathConversion(asciimath: "tt", tex: r"\mathtt"),
        _AsciiMathConversion(asciimath: "mathtt", tex: r"\mathtt"),
        _AsciiMathConversion(asciimath: "fr", tex: r"\mathfrak"),
        _AsciiMathConversion(asciimath: "mathfrak", tex: r"\mathfrak"),
      ];

  List<_AsciiMathConversion> get binarySymbols => const [
        _AsciiMathConversion(asciimath: "root", tex: r"\sqrt", firstIsOption: true),
        _AsciiMathConversion(asciimath: "frac", tex: r"\frac"),
        _AsciiMathConversion(asciimath: "stackrel", tex: r"\stackrel"),
        _AsciiMathConversion(asciimath: "overset", tex: r"\overset"),
        _AsciiMathConversion(asciimath: "underset", tex: r"\underset"),
        _AsciiMathConversion(asciimath: "color", tex: r"\color", rawFirst: true),
      ];

  List<_AsciiMathConversion> get aloneSymbol => arithmeticSymbols + relationSymbols + constantSymbols;

  List<_AsciiMathConversion> get fullSymbol =>
      greekLetters +
      arithmeticSymbols +
      relationSymbols +
      constantSymbols +
      leftBracketSymbols +
      rightBracketSymbols +
      unarySymbols +
      binarySymbols;

  Map<String, _AsciiMathConversion> get symbolMap => {
        for (_AsciiMathConversion s in fullSymbol) ...{
          s.asciimath: s,
          s.tex ?? "": s,
        }
      };
}
