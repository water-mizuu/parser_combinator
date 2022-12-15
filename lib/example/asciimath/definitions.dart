class AsciiMathConversion implements Comparable<AsciiMathConversion> {
  final String asciimath;
  final bool rawFirst;
  final bool rawSecond;
  final bool firstIsOption;
  final String? tex;
  final (String, String)? rewriteLeftRight;

  const AsciiMathConversion({
    required this.asciimath,
    this.tex,
    this.firstIsOption = false,
    this.rawFirst = false,
    this.rawSecond = false,
    this.rewriteLeftRight,
  });

  @override
  int compareTo(AsciiMathConversion other) => other.asciimath.length - asciimath.length;
}

mixin AsciiMathDefinitions {
  final List<AsciiMathConversion> greekLetters = const [
    AsciiMathConversion(asciimath: "alpha", tex: r"\alpha"),
    AsciiMathConversion(asciimath: "beta", tex: r"\beta"),
    AsciiMathConversion(asciimath: "gamma", tex: r"\gamma"),
    AsciiMathConversion(asciimath: "Gamma", tex: r"\Gamma"),
    AsciiMathConversion(asciimath: "delta", tex: r"\delta"),
    AsciiMathConversion(asciimath: "Delta", tex: r"\Delta"),
    AsciiMathConversion(asciimath: "epsilon", tex: r"\epsilon"),
    AsciiMathConversion(asciimath: "varepsilon", tex: r"\varepsilon"),
    AsciiMathConversion(asciimath: "zeta", tex: r"\zeta"),
    AsciiMathConversion(asciimath: "eta", tex: r"\eta"),
    AsciiMathConversion(asciimath: "theta", tex: r"\theta"),
    AsciiMathConversion(asciimath: "Theta", tex: r"\Theta"),
    AsciiMathConversion(asciimath: "vartheta", tex: r"\vartheta"),
    AsciiMathConversion(asciimath: "iota", tex: r"\iota"),
    AsciiMathConversion(asciimath: "kappa", tex: r"\kappa"),
    AsciiMathConversion(asciimath: "lambda", tex: r"\lambda"),
    AsciiMathConversion(asciimath: "Lambda", tex: r"\Lambda"),
    AsciiMathConversion(asciimath: "mu", tex: r"\mu"),
    AsciiMathConversion(asciimath: "nu", tex: r"\nu"),
    AsciiMathConversion(asciimath: "xi", tex: r"\xi"),
    AsciiMathConversion(asciimath: "Xi", tex: r"\Xi"),
    AsciiMathConversion(asciimath: "pi", tex: r"\pi"),
    AsciiMathConversion(asciimath: "Pi", tex: r"\Pi"),
    AsciiMathConversion(asciimath: "rho", tex: r"\rho"),
    AsciiMathConversion(asciimath: "sigma", tex: r"\sigma"),
    AsciiMathConversion(asciimath: "Sigma", tex: r"\Sigma"),
    AsciiMathConversion(asciimath: "tau", tex: r"\tau"),
    AsciiMathConversion(asciimath: "upsilon", tex: r"\upsilon"),
    AsciiMathConversion(asciimath: "phi", tex: r"\phi"),
    AsciiMathConversion(asciimath: "Phi", tex: r"\Phi"),
    AsciiMathConversion(asciimath: "varphi", tex: r"\varphi"),
    AsciiMathConversion(asciimath: "chi", tex: r"\chi"),
    AsciiMathConversion(asciimath: "psi", tex: r"\psi"),
    AsciiMathConversion(asciimath: "Psi", tex: r"\Psi"),
    AsciiMathConversion(asciimath: "omega", tex: r"\omega"),
    AsciiMathConversion(asciimath: "Omega", tex: r"\Omega"),
  ];

  final List<AsciiMathConversion> arithmeticSymbols = const [
    AsciiMathConversion(asciimath: "+", tex: "+"),
    AsciiMathConversion(asciimath: "*", tex: "*"),
    AsciiMathConversion(asciimath: "//", tex: "/"),
    AsciiMathConversion(asciimath: "&", tex: "&"),
    AsciiMathConversion(asciimath: "'", tex: "'"),
    AsciiMathConversion(asciimath: "::", tex: "::"),
    AsciiMathConversion(asciimath: ",", tex: ","),
    AsciiMathConversion(asciimath: "°", tex: r"^\circ"),
  ];

  final List<AsciiMathConversion> relationSymbols = const [
    AsciiMathConversion(asciimath: "&=", tex: "&="),
    AsciiMathConversion(asciimath: "=", tex: "="),
    AsciiMathConversion(asciimath: ":=", tex: ":="),
    AsciiMathConversion(asciimath: ":|:", tex: r"\|"),
    AsciiMathConversion(asciimath: "=>", tex: r"\Rightarrow"),
    AsciiMathConversion(asciimath: "approx", tex: r"\approx"),
    AsciiMathConversion(asciimath: "~~", tex: r"\approx"),
    AsciiMathConversion(asciimath: "cong", tex: r"\cong"),
    AsciiMathConversion(asciimath: "~=", tex: r"\cong"),
    AsciiMathConversion(asciimath: "equiv", tex: r"\equiv"),
    AsciiMathConversion(asciimath: "-=", tex: r"\equiv"),
    AsciiMathConversion(asciimath: "exists", tex: r"\exists"),
    AsciiMathConversion(asciimath: "EE", tex: r"\exists"),
    AsciiMathConversion(asciimath: "forall", tex: r"\forall"),
    AsciiMathConversion(asciimath: "AA", tex: r"\forall"),
    AsciiMathConversion(asciimath: ">=", tex: r"\ge"),
    AsciiMathConversion(asciimath: "ge", tex: r"\ge"),
    AsciiMathConversion(asciimath: "gt=", tex: r"\geq"),
    AsciiMathConversion(asciimath: "geq", tex: r"\geq"),
    AsciiMathConversion(asciimath: ">", tex: r"\gt"),
    AsciiMathConversion(asciimath: "gt", tex: r"\gt"),
    AsciiMathConversion(asciimath: "in", tex: r"\in"),
    AsciiMathConversion(asciimath: "<=", tex: r"\le"),
    AsciiMathConversion(asciimath: "le", tex: r"\le"),
    AsciiMathConversion(asciimath: "lt=", tex: r"\leq"),
    AsciiMathConversion(asciimath: "leq", tex: r"\leq"),
    AsciiMathConversion(asciimath: "<", tex: r"\lt"),
    AsciiMathConversion(asciimath: "lt", tex: r"\lt"),
    AsciiMathConversion(asciimath: "models", tex: r"\models"),
    AsciiMathConversion(asciimath: "|==", tex: r"\models"),
    AsciiMathConversion(asciimath: "!=", tex: r"\ne"),
    AsciiMathConversion(asciimath: "ne", tex: r"\ne"),
    AsciiMathConversion(asciimath: "notin", tex: r"\notin"),
    AsciiMathConversion(asciimath: "!in", tex: r"\notin"),
    AsciiMathConversion(asciimath: "prec", tex: r"\prec"),
    AsciiMathConversion(asciimath: "-lt", tex: r"\prec"),
    AsciiMathConversion(asciimath: "-<", tex: r"\prec"),
    AsciiMathConversion(asciimath: "preceq", tex: r"\preceq"),
    AsciiMathConversion(asciimath: "-<=", tex: r"\preceq"),
    AsciiMathConversion(asciimath: "propto", tex: r"\propto"),
    AsciiMathConversion(asciimath: "prop", tex: r"\propto"),
    AsciiMathConversion(asciimath: "subset", tex: r"\subset"),
    AsciiMathConversion(asciimath: "sub", tex: r"\subset"),
    AsciiMathConversion(asciimath: "subseteq", tex: r"\subseteq"),
    AsciiMathConversion(asciimath: "sube", tex: r"\subseteq"),
    AsciiMathConversion(asciimath: "succ", tex: r"\succ"),
    AsciiMathConversion(asciimath: ">-", tex: r"\succ"),
    AsciiMathConversion(asciimath: "succeq", tex: r"\succeq"),
    AsciiMathConversion(asciimath: ">-=", tex: r"\succeq"),
    AsciiMathConversion(asciimath: "supset", tex: r"\supset"),
    AsciiMathConversion(asciimath: "sup", tex: r"\supset"),
    AsciiMathConversion(asciimath: "supseteq", tex: r"\supseteq"),
    AsciiMathConversion(asciimath: "supe", tex: r"\supseteq"),
    AsciiMathConversion(asciimath: "vdash", tex: r"\vdash"),
    AsciiMathConversion(asciimath: "|--", tex: r"\vdash"),
  ];

  final List<AsciiMathConversion> leftBracketSymbols = const [
    AsciiMathConversion(asciimath: "langle", tex: r"\langle"),
    AsciiMathConversion(asciimath: "lbrace", tex: r"\lbrace"),
    AsciiMathConversion(asciimath: "(:", tex: r"\langle"),
    AsciiMathConversion(asciimath: "<<", tex: r"\langle"),
    AsciiMathConversion(asciimath: "{:", tex: "."),
    AsciiMathConversion(asciimath: "(", tex: "("),
    AsciiMathConversion(asciimath: "[", tex: "["),
    AsciiMathConversion(asciimath: "⌊", tex: "⌊"),
    AsciiMathConversion(asciimath: "{", tex: r"\lbrace"),
    AsciiMathConversion(asciimath: "||", tex: r"\|"),
    // AsciiMathConversion(asciimath: "|", tex: "|"),
  ];

  final List<AsciiMathConversion> rightBracketSymbols = const [
    AsciiMathConversion(asciimath: "rangle", tex: r"\rangle"),
    AsciiMathConversion(asciimath: "rbrace", tex: r"\rbrace"),
    AsciiMathConversion(asciimath: ":)", tex: r"\rangle"),
    AsciiMathConversion(asciimath: ">>", tex: r"\rangle"),
    AsciiMathConversion(asciimath: ":}", tex: "."),
    AsciiMathConversion(asciimath: ")", tex: ")"),
    AsciiMathConversion(asciimath: "]", tex: "]"),
    AsciiMathConversion(asciimath: "}", tex: r"\rbrace"),
    AsciiMathConversion(asciimath: "||", tex: r"\|"),
    // AsciiMathConversion(asciimath: "|", tex: "|"),
  ];

  final List<AsciiMathConversion> constantSymbols = const [
    AsciiMathConversion(asciimath: "sin", tex: r"\sin"),
    AsciiMathConversion(asciimath: "cos", tex: r"\cos"),
    AsciiMathConversion(asciimath: "tan", tex: r"\tan"),
    AsciiMathConversion(asciimath: "arcsin", tex: r"\arcsin"),
    AsciiMathConversion(asciimath: "arccos", tex: r"\arccos"),
    AsciiMathConversion(asciimath: "arctan", tex: r"\arctan"),
    AsciiMathConversion(asciimath: "sinh", tex: r"\sinh"),
    AsciiMathConversion(asciimath: "cosh", tex: r"\cosh"),
    AsciiMathConversion(asciimath: "tanh", tex: r"\tanh"),
    AsciiMathConversion(asciimath: "cot", tex: r"\cot"),
    AsciiMathConversion(asciimath: "coth", tex: r"\coth"),
    AsciiMathConversion(asciimath: "sech", tex: r"\operatorname{sech}"),
    AsciiMathConversion(asciimath: "csch", tex: r"\operatorname{csch}"),
    AsciiMathConversion(asciimath: "sec", tex: r"\sec"),
    AsciiMathConversion(asciimath: "csc", tex: r"\csc"),
    AsciiMathConversion(asciimath: "log", tex: r"\log"),
    AsciiMathConversion(asciimath: "ln", tex: r"\ln"),
    AsciiMathConversion(asciimath: "deg", tex: "°"),
    AsciiMathConversion(asciimath: "da", tex: "da"),
    AsciiMathConversion(asciimath: "db", tex: "db"),
    AsciiMathConversion(asciimath: "dc", tex: "dc"),
    AsciiMathConversion(asciimath: "dd", tex: "dd"),
    AsciiMathConversion(asciimath: "de", tex: "de"),
    AsciiMathConversion(asciimath: "df", tex: "df"),
    AsciiMathConversion(asciimath: "dg", tex: "dg"),
    AsciiMathConversion(asciimath: "dh", tex: "dh"),
    AsciiMathConversion(asciimath: "di", tex: "di"),
    AsciiMathConversion(asciimath: "dj", tex: "dj"),
    AsciiMathConversion(asciimath: "dk", tex: "dk"),
    AsciiMathConversion(asciimath: "dl", tex: "dl"),
    AsciiMathConversion(asciimath: "dm", tex: "dm"),
    AsciiMathConversion(asciimath: "dn", tex: "dn"),
    AsciiMathConversion(asciimath: "do", tex: "do"),
    AsciiMathConversion(asciimath: "dp", tex: "dp"),
    AsciiMathConversion(asciimath: "dq", tex: "dq"),
    AsciiMathConversion(asciimath: "dr", tex: "dr"),
    AsciiMathConversion(asciimath: "ds", tex: "ds"),
    AsciiMathConversion(asciimath: "dt", tex: "dt"),
    AsciiMathConversion(asciimath: "du", tex: "du"),
    AsciiMathConversion(asciimath: "dv", tex: "dv"),
    AsciiMathConversion(asciimath: "dw", tex: "dw"),
    AsciiMathConversion(asciimath: "dx", tex: "dx"),
    AsciiMathConversion(asciimath: "dy", tex: "dy"),
    AsciiMathConversion(asciimath: "dz", tex: "dz"),
    AsciiMathConversion(asciimath: "prime", tex: "'"),
    AsciiMathConversion(asciimath: "implies", tex: r"\implies"),
    AsciiMathConversion(asciimath: "ell", tex: r"\ell"),
    AsciiMathConversion(asciimath: "epsi", tex: r"\epsilon"),
    AsciiMathConversion(asciimath: "leftrightarrow", tex: r"\leftrightarrow"),
    AsciiMathConversion(asciimath: "Leftrightarrow", tex: r"\Leftrightarrow"),
    AsciiMathConversion(asciimath: "rightarrow", tex: r"\rightarrow"),
    AsciiMathConversion(asciimath: "Rightarrow", tex: r"\Rightarrow"),
    AsciiMathConversion(asciimath: "backslash", tex: r"\backslash"),
    AsciiMathConversion(asciimath: "leftarrow", tex: r"\leftarrow"),
    AsciiMathConversion(asciimath: "Leftarrow", tex: r"\Leftarrow"),
    AsciiMathConversion(asciimath: "setminus", tex: r"\setminus"),
    AsciiMathConversion(asciimath: "bigwedge", tex: r"\bigwedge"),
    AsciiMathConversion(asciimath: "diamond", tex: r"\diamond"),
    AsciiMathConversion(asciimath: "bowtie", tex: r"\bowtie"),
    AsciiMathConversion(asciimath: "bigvee", tex: r"\bigvee"),
    AsciiMathConversion(asciimath: "bigcap", tex: r"\bigcap"),
    AsciiMathConversion(asciimath: "bigcup", tex: r"\bigcup"),
    AsciiMathConversion(asciimath: "square", tex: r"\square"),
    AsciiMathConversion(asciimath: "lamda", tex: r"\lambda"),
    AsciiMathConversion(asciimath: "Lamda", tex: r"\Lambda"),
    AsciiMathConversion(asciimath: "aleph", tex: r"\aleph"),
    AsciiMathConversion(asciimath: "angle", tex: r"\angle"),
    AsciiMathConversion(asciimath: "frown", tex: r"\frown"),
    AsciiMathConversion(asciimath: "limits", tex: r"\limits"),
    AsciiMathConversion(asciimath: "qquad", tex: r"\qquad"),
    AsciiMathConversion(asciimath: "cdots", tex: r"\cdots"),
    AsciiMathConversion(asciimath: "vdots", tex: r"\vdots"),
    AsciiMathConversion(asciimath: "ddots", tex: r"\ddots"),
    AsciiMathConversion(asciimath: "cdot", tex: r"\cdot"),
    AsciiMathConversion(asciimath: "star", tex: r"\star"),
    AsciiMathConversion(asciimath: "|><|", tex: r"\bowtie"),
    AsciiMathConversion(asciimath: "circ", tex: r"\circ"),
    AsciiMathConversion(asciimath: "int", tex: r"\int"),
    AsciiMathConversion(asciimath: "oint", tex: r"\oint"),
    AsciiMathConversion(asciimath: "ointlim", tex: r"\oint\limits"),
    AsciiMathConversion(asciimath: "grad", tex: r"\nabla"),
    AsciiMathConversion(asciimath: "quad", tex: r"\quad"),
    AsciiMathConversion(asciimath: "uarr", tex: r"\uparrow"),
    AsciiMathConversion(asciimath: "darr", tex: r"\downarrow"),
    AsciiMathConversion(asciimath: "downarrow", tex: r"\downarrow"),
    AsciiMathConversion(asciimath: "rarr", tex: r"\rightarrow"),
    AsciiMathConversion(asciimath: ">->>", tex: r"\twoheadrightarrowtail"),
    AsciiMathConversion(asciimath: "larr", tex: r"\leftarrow"),
    AsciiMathConversion(asciimath: "harr", tex: r"\leftrightarrow"),
    AsciiMathConversion(asciimath: "rArr", tex: r"\Rightarrow"),
    AsciiMathConversion(asciimath: "lArr", tex: r"\Leftarrow"),
    AsciiMathConversion(asciimath: "hArr", tex: r"\Leftrightarrow"),
    AsciiMathConversion(asciimath: "ast", tex: r"\ast"),
    AsciiMathConversion(asciimath: "***", tex: r"\star"),
    AsciiMathConversion(asciimath: "|><", tex: r"\ltimes"),
    AsciiMathConversion(asciimath: "><|", tex: r"\rtimes"),
    AsciiMathConversion(asciimath: "^^^", tex: r"\bigwedge"),
    AsciiMathConversion(asciimath: "vvv", tex: r"\bigvee"),
    AsciiMathConversion(asciimath: "cap", tex: r"\cap"),
    AsciiMathConversion(asciimath: "nnn", tex: r"\bigcap"),
    AsciiMathConversion(asciimath: "cup", tex: r"\cup"),
    AsciiMathConversion(asciimath: "uuu", tex: r"\bigcup"),
    AsciiMathConversion(asciimath: "not", tex: r"\neg"),
    AsciiMathConversion(asciimath: "<=>", tex: r"\Leftrightarrow"),
    AsciiMathConversion(asciimath: "_|_", tex: r"\bot"),
    AsciiMathConversion(asciimath: "bot", tex: r"\bot"),
    AsciiMathConversion(asciimath: "int", tex: r"\int"),
    AsciiMathConversion(asciimath: "intlim", tex: r"\int\limits"),
    AsciiMathConversion(asciimath: "del", tex: r"\partial"),
    AsciiMathConversion(asciimath: "...", tex: r"\ldots"),
    AsciiMathConversion(asciimath: r"/_\", tex: r"\triangle"),
    AsciiMathConversion(asciimath: "|__", tex: r"\lfloor"),
    AsciiMathConversion(asciimath: "__|", tex: r"\rfloor"),
    AsciiMathConversion(asciimath: "dim", tex: r"\dim"),
    AsciiMathConversion(asciimath: "mod", tex: r"\operatorname{mod}"),
    AsciiMathConversion(asciimath: "lub", tex: r"\operatorname{lub}"),
    AsciiMathConversion(asciimath: "glb", tex: r"\operatorname{glb}"),
    AsciiMathConversion(asciimath: ">->", tex: r"\rightarrowtail"),
    AsciiMathConversion(asciimath: "->>", tex: r"\twoheadrightarrow"),
    AsciiMathConversion(asciimath: "|->", tex: r"\mapsto"),
    AsciiMathConversion(asciimath: "lim", tex: r"\lim\limits"),
    AsciiMathConversion(asciimath: "Lim", tex: r"\operatorname{Lim}"),
    AsciiMathConversion(asciimath: "and", tex: r"\quad\text{and}\quad"),
    AsciiMathConversion(asciimath: "**", tex: r"\ast"),
    AsciiMathConversion(asciimath: "//", tex: "/"),
    AsciiMathConversion(asciimath: r"\", tex: r"\,"),
    AsciiMathConversion(asciimath: r"\\", tex: r"\backslash"),
    AsciiMathConversion(asciimath: "xx", tex: r"\times"),
    AsciiMathConversion(asciimath: "-:", tex: r"\div"),
    AsciiMathConversion(asciimath: "o+", tex: r"\oplus"),
    AsciiMathConversion(asciimath: "ox", tex: r"\otimes"),
    AsciiMathConversion(asciimath: "o.", tex: r"\odot"),
    AsciiMathConversion(asciimath: "^^", tex: r"\wedge"),
    AsciiMathConversion(asciimath: "vv", tex: r"\vee"),
    AsciiMathConversion(asciimath: "nn", tex: r"\cap"),
    AsciiMathConversion(asciimath: "uu", tex: r"\cup"),
    AsciiMathConversion(asciimath: "TT", tex: r"\top"),
    AsciiMathConversion(asciimath: "+-", tex: r"\pm"),
    AsciiMathConversion(asciimath: "-+", tex: r"\mp"),
    AsciiMathConversion(asciimath: "O/", tex: r"\emptyset"),
    AsciiMathConversion(asciimath: "oo", tex: r"\infty"),
    AsciiMathConversion(asciimath: ":.", tex: r"\therefore"),
    AsciiMathConversion(asciimath: ":'", tex: r"\because"),
    AsciiMathConversion(asciimath: "/_", tex: r"\angle"),
    AsciiMathConversion(asciimath: "|~", tex: r"\lceil"),
    AsciiMathConversion(asciimath: "~|", tex: r"\rceil"),
    AsciiMathConversion(asciimath: "RR", tex: r"\mathbb{R}"),
    AsciiMathConversion(asciimath: "cc", tex: r"\mathbf{C}"),
    AsciiMathConversion(asciimath: "CC", tex: r"\mathbb{C}"),
    AsciiMathConversion(asciimath: "NN", tex: r"\mathbb{N}"),
    AsciiMathConversion(asciimath: "ZZ", tex: r"\mathbb{Z}"),
    AsciiMathConversion(asciimath: "QQ", tex: r"\mathbb{Q}"),
    AsciiMathConversion(asciimath: "II", tex: r"\mathbb{I}"),
    AsciiMathConversion(asciimath: "real", tex: r"\mathbb{R}"),
    AsciiMathConversion(asciimath: "complex", tex: r"\mathbb{C}"),
    AsciiMathConversion(asciimath: "natural", tex: r"\mathbb{N}"),
    AsciiMathConversion(asciimath: "integer", tex: r"\mathbb{Z}"),
    AsciiMathConversion(asciimath: "rational", tex: r"\mathbb{Q}"),
    AsciiMathConversion(asciimath: "imaginary", tex: r"\mathbb{I}"),
    AsciiMathConversion(asciimath: "constant", tex: r"\mathbf{C}"),
    AsciiMathConversion(asciimath: "->", tex: r"\to"),
    AsciiMathConversion(asciimath: "or", tex: r"\quad\text{or}\quad"),
    AsciiMathConversion(asciimath: "if", tex: r"\quad\text{if}\quad"),
    AsciiMathConversion(asciimath: "iff", tex: r"\iff"),
    AsciiMathConversion(asciimath: "*", tex: r"\cdot"),
    AsciiMathConversion(asciimath: "@", tex: r"\circ"),
    AsciiMathConversion(asciimath: "%", tex: r"\%"),
    AsciiMathConversion(asciimath: "boxempty", tex: r"\square"),
    AsciiMathConversion(asciimath: "lambda", tex: r"\lambda"),
    AsciiMathConversion(asciimath: "Lambda", tex: r"\Lambda"),
    AsciiMathConversion(asciimath: "nabla", tex: r"\nabla"),
    AsciiMathConversion(asciimath: "uparrow", tex: r"\uparrow"),
    AsciiMathConversion(asciimath: "downarrow", tex: r"\downarrow"),
    AsciiMathConversion(asciimath: "twoheadrightarrowtail", tex: r"\twoheadrightarrowtail"),
    AsciiMathConversion(asciimath: "ltimes", tex: r"\ltimes"),
    AsciiMathConversion(asciimath: "rtimes", tex: r"\rtimes"),
    AsciiMathConversion(asciimath: "neg", tex: r"\neg"),
    AsciiMathConversion(asciimath: "partial", tex: r"\partial"),
    AsciiMathConversion(asciimath: "ldots", tex: r"\ldots"),
    AsciiMathConversion(asciimath: "triangle", tex: r"\triangle"),
    AsciiMathConversion(asciimath: "lfloor", tex: r"\lfloor"),
    AsciiMathConversion(asciimath: "rfloor", tex: r"\rfloor"),
    AsciiMathConversion(asciimath: "rightarrowtail", tex: r"\rightarrowtail"),
    AsciiMathConversion(asciimath: "twoheadrightarrow", tex: r"\twoheadrightarrow"),
    AsciiMathConversion(asciimath: "mapsto", tex: r"\mapsto"),
    AsciiMathConversion(asciimath: "times", tex: r"\times"),
    AsciiMathConversion(asciimath: "div", tex: r"\div"),
    AsciiMathConversion(asciimath: "divide", tex: r"\div"),
    AsciiMathConversion(asciimath: "oplus", tex: r"\oplus"),
    AsciiMathConversion(asciimath: "otimes", tex: r"\otimes"),
    AsciiMathConversion(asciimath: "odot", tex: r"\odot"),
    AsciiMathConversion(asciimath: "wedge", tex: r"\wedge"),
    AsciiMathConversion(asciimath: "vee", tex: r"\vee"),
    AsciiMathConversion(asciimath: "top", tex: r"\top"),
    AsciiMathConversion(asciimath: "pm", tex: r"\pm"),
    AsciiMathConversion(asciimath: "emptyset", tex: r"\emptyset"),
    AsciiMathConversion(asciimath: "infty", tex: r"\infty"),
    AsciiMathConversion(asciimath: "therefore", tex: r"\therefore"),
    AsciiMathConversion(asciimath: "because", tex: r"\because"),
    AsciiMathConversion(asciimath: "lceil", tex: r"\lceil"),
    AsciiMathConversion(asciimath: "rceil", tex: r"\rceil"),
    AsciiMathConversion(asciimath: "to", tex: r"\to"),
    AsciiMathConversion(asciimath: "langle", tex: r"\langle"),
    AsciiMathConversion(asciimath: "lceiling", tex: r"\lceil"),
    AsciiMathConversion(asciimath: "rceiling", tex: r"\rceil"),
    AsciiMathConversion(asciimath: "max", tex: r"\max"),
    AsciiMathConversion(asciimath: "min", tex: r"\min"),
    AsciiMathConversion(asciimath: "prod", tex: r"\prod\limits"),
    AsciiMathConversion(asciimath: "sum", tex: r"\sum\limits"),
  ];

  final List<AsciiMathConversion> unarySymbols = const [
    AsciiMathConversion(asciimath: "text", tex: r"\text"),
    AsciiMathConversion(asciimath: "ce", tex: r"\ce"),
    AsciiMathConversion(asciimath: "sqrt", tex: r"\sqrt"),
    AsciiMathConversion(asciimath: "boxed", tex: r"\boxed"),
    AsciiMathConversion(asciimath: "abs", rewriteLeftRight: ("|", "|")),
    AsciiMathConversion(asciimath: "norm", rewriteLeftRight: (r"\|", r"\|")),
    AsciiMathConversion(asciimath: "floor", rewriteLeftRight: (r"\lfloor", r"\rfloor")),
    AsciiMathConversion(asciimath: "ceil", rewriteLeftRight: (r"\lceil", r"\rceil")),
    AsciiMathConversion(asciimath: "det", tex: r"\det"),
    AsciiMathConversion(asciimath: "exp", tex: r"\exp"),
    AsciiMathConversion(asciimath: "gcd", tex: r"\gcd"),
    AsciiMathConversion(asciimath: "gcf", tex: r"\gcf"),
    AsciiMathConversion(asciimath: "lcm", tex: r"\operatorname{lcm}"),
    AsciiMathConversion(asciimath: "lcd", tex: r"\operatorname{lcd}"),
    AsciiMathConversion(asciimath: "cancel", tex: r"\cancel"),
    AsciiMathConversion(asciimath: "Sqrt", tex: r"\Sqrt"),
    AsciiMathConversion(asciimath: "hat", tex: r"\hat"),
    AsciiMathConversion(asciimath: "bar", tex: r"\overline"),
    AsciiMathConversion(asciimath: "overline", tex: r"\overline"),
    AsciiMathConversion(asciimath: "vec", tex: r"\vec"),
    AsciiMathConversion(asciimath: "tilde", tex: r"\tilde"),
    AsciiMathConversion(asciimath: "dot", tex: r"\dot"),
    AsciiMathConversion(asciimath: "ddot", tex: r"\ddot"),
    AsciiMathConversion(asciimath: "ul", tex: r"\underline"),
    AsciiMathConversion(asciimath: "underline", tex: r"\underline"),
    AsciiMathConversion(asciimath: "ubrace", tex: r"\underbrace"),
    AsciiMathConversion(asciimath: "underbrace", tex: r"\underbrace"),
    AsciiMathConversion(asciimath: "obrace", tex: r"\overbrace"),
    AsciiMathConversion(asciimath: "overbrace", tex: r"\overbrace"),
    AsciiMathConversion(asciimath: "bb", tex: r"\mathbf"),
    AsciiMathConversion(asciimath: "mathbf", tex: "mathbf"),
    AsciiMathConversion(asciimath: "sf", tex: r"\mathsf"),
    AsciiMathConversion(asciimath: "mathsf", tex: "mathsf"),
    AsciiMathConversion(asciimath: "bbb", tex: r"\mathbb"),
    AsciiMathConversion(asciimath: "mathbb", tex: r"\mathbb"),
    AsciiMathConversion(asciimath: "cc", tex: r"\mathcal"),
    AsciiMathConversion(asciimath: "mathcal", tex: r"\mathcal"),
    AsciiMathConversion(asciimath: "tt", tex: r"\mathtt"),
    AsciiMathConversion(asciimath: "mathtt", tex: r"\mathtt"),
    AsciiMathConversion(asciimath: "fr", tex: r"\mathfrak"),
    AsciiMathConversion(asciimath: "mathfrak", tex: r"\mathfrak"),
  ];

  final List<AsciiMathConversion> binarySymbols = const [
    AsciiMathConversion(asciimath: "root", tex: r"\sqrt", firstIsOption: true),
    AsciiMathConversion(asciimath: "frac", tex: r"\frac"),
    AsciiMathConversion(asciimath: "stackrel", tex: r"\stackrel"),
    AsciiMathConversion(asciimath: "overset", tex: r"\overset"),
    AsciiMathConversion(asciimath: "underset", tex: r"\underset"),
    AsciiMathConversion(asciimath: "color", tex: r"\color", rawFirst: true),
  ];

  List<AsciiMathConversion> get aloneSymbol => [
    ...arithmeticSymbols,
    ...relationSymbols,
    ...constantSymbols,
  ];

  List<AsciiMathConversion> get fullSymbol => [
    ...greekLetters,
    ...arithmeticSymbols,
    ...relationSymbols,
    ...leftBracketSymbols,
    ...rightBracketSymbols,
    ...constantSymbols,
    ...unarySymbols,
    ...binarySymbols,
  ];

  Map<String, AsciiMathConversion> get symbolMap => {
    for (AsciiMathConversion s in fullSymbol) ...{
      s.asciimath: s,
      s.tex ?? "": s,
    }
  };
}