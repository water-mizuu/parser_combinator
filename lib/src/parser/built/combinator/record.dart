import "package:parser_combinator/parser_combinator.dart";
// import "package:parser_combinator/src/parser/base/core/mixin/combinator_parser.dart";

// class Record1Parser<V1> extends Parser<(V1,)> with CombinatorParser<(V1,)> {
//   @override
//   List<Parser<void>> children;

//   Parser<V1> get parser1 => children[0] as Parser<V1>;

//   Record1Parser(
//     Parser<V1> parser1,
//   ) : children = <Parser<void>>[
//           parser1,
//         ];
//   Record1Parser._empty() : children = <Parser<void>>[];

//   @override
//   void gllParseOn(Context<void> context, Trampoline trampoline, Continuation<(V1,)> continuation) {
//     trampoline.add(parser1, context, (Context<V1> r1) {
//       return switch (r1) {
//         Empty _ => throw UnsupportedError("A record-typed parser cannot have an empty element!"),
//         Failure _ => continuation(r1),
//         Success<V1>(value: V1 v1) => continuation(r1.success((v1,))),
//       };
//     });
//   }

//   @override
//   Context<(V1,)> pegParseOn(Context<void> context, PegHandler handler) {
//     return switch (handler.parse(parser1, context)) {
//       Empty _ => throw UnsupportedError("A record-typed parser cannot have an empty element!"),
//       Failure r1 => r1 as Context<(V1,)>,
//       Success<V1> r1 && Success<V1>(value: V1 v1) => r1.success((v1,)),
//     };
//   }

//   @override
//   CombinatorParser<(V1,)> generateEmpty() {
//     return Record1Parser<V1>._empty();
//   }
// }

Parser<(V1,)> record1<V1>((Parser<V1>,) record) {
  return sequence<Object?>(<Parser<Object?>>[
    record.$1,
  ]).map((List<Object?> values) => (values[0] as V1,));
}

Parser<
    (
      V1,
      V2,
    )> record2<V1, V2>(
    (
      Parser<V1>,
      Parser<V2>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
    )> record3<V1, V2, V3>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
    )> record4<V1, V2, V3, V4>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
    )> record5<V1, V2, V3, V4, V5>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
    )> record6<V1, V2, V3, V4, V5, V6>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
    )> record7<V1, V2, V3, V4, V5, V6, V7>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
    )> record8<V1, V2, V3, V4, V5, V6, V7, V8>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
    )> record9<V1, V2, V3, V4, V5, V6, V7, V8, V9>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
      V10,
    )> record10<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
      Parser<V10>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
    record.$10,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
        values[9] as V10,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
      V10,
      V11,
    )> record11<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
      Parser<V10>,
      Parser<V11>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
    record.$10,
    record.$11,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
        values[9] as V10,
        values[10] as V11,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
      V10,
      V11,
      V12,
    )> record12<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
      Parser<V10>,
      Parser<V11>,
      Parser<V12>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
    record.$10,
    record.$11,
    record.$12,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
        values[9] as V10,
        values[10] as V11,
        values[11] as V12,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
      V10,
      V11,
      V12,
      V13,
    )> record13<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
      Parser<V10>,
      Parser<V11>,
      Parser<V12>,
      Parser<V13>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
    record.$10,
    record.$11,
    record.$12,
    record.$13,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
        values[9] as V10,
        values[10] as V11,
        values[11] as V12,
        values[12] as V13,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
      V10,
      V11,
      V12,
      V13,
      V14,
    )> record14<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
      Parser<V10>,
      Parser<V11>,
      Parser<V12>,
      Parser<V13>,
      Parser<V14>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
    record.$10,
    record.$11,
    record.$12,
    record.$13,
    record.$14,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
        values[9] as V10,
        values[10] as V11,
        values[11] as V12,
        values[12] as V13,
        values[13] as V14,
      ));
}

Parser<
    (
      V1,
      V2,
      V3,
      V4,
      V5,
      V6,
      V7,
      V8,
      V9,
      V10,
      V11,
      V12,
      V13,
      V14,
      V15,
    )> record15<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15>(
    (
      Parser<V1>,
      Parser<V2>,
      Parser<V3>,
      Parser<V4>,
      Parser<V5>,
      Parser<V6>,
      Parser<V7>,
      Parser<V8>,
      Parser<V9>,
      Parser<V10>,
      Parser<V11>,
      Parser<V12>,
      Parser<V13>,
      Parser<V14>,
      Parser<V15>,
    ) record) {
  return sequence(<Parser<Object?>>[
    record.$1,
    record.$2,
    record.$3,
    record.$4,
    record.$5,
    record.$6,
    record.$7,
    record.$8,
    record.$9,
    record.$10,
    record.$11,
    record.$12,
    record.$13,
    record.$14,
    record.$15,
  ]).map((List<Object?> values) => (
        values[0] as V1,
        values[1] as V2,
        values[2] as V3,
        values[3] as V4,
        values[4] as V5,
        values[5] as V6,
        values[6] as V7,
        values[7] as V8,
        values[8] as V9,
        values[9] as V10,
        values[10] as V11,
        values[11] as V12,
        values[12] as V13,
        values[13] as V14,
        values[14] as V15,
      ));
}

extension SequenceParser1Extension<V1> on (Parser<V1>,) {
  Parser<(V1,)> sequence() => record1(this);
}

extension SequenceParser2Extension<V1, V2> on (
  Parser<V1>,
  Parser<V2>,
) {
  Parser<
      (
        V1,
        V2,
      )> sequence() => record2(this);
}

extension SequenceParser3Extension<V1, V2, V3> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
      )> sequence() => record3(this);
}

extension SequenceParser4Extension<V1, V2, V3, V4> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
      )> sequence() => record4(this);
}

extension SequenceParser5Extension<V1, V2, V3, V4, V5> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
      )> sequence() => record5(this);
}

extension SequenceParser6Extension<V1, V2, V3, V4, V5, V6> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
      )> sequence() => record6(this);
}

extension SequenceParser7Extension<V1, V2, V3, V4, V5, V6, V7> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
      )> sequence() => record7(this);
}

extension SequenceParser8Extension<V1, V2, V3, V4, V5, V6, V7, V8> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
      )> sequence() => record8(this);
}

extension SequenceParser9Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
      )> sequence() => record9(this);
}

extension SequenceParser10Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
  Parser<V10>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
      )> sequence() => record10(this);
}

extension SequenceParser11Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
  Parser<V10>,
  Parser<V11>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
        V11,
      )> sequence() => record11(this);
}

extension SequenceParser12Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
  Parser<V10>,
  Parser<V11>,
  Parser<V12>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
        V11,
        V12,
      )> sequence() => record12(this);
}

extension SequenceParser13Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
  Parser<V10>,
  Parser<V11>,
  Parser<V12>,
  Parser<V13>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
        V11,
        V12,
        V13,
      )> sequence() => record13(this);
}

extension SequenceParser14Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
  Parser<V10>,
  Parser<V11>,
  Parser<V12>,
  Parser<V13>,
  Parser<V14>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
        V11,
        V12,
        V13,
        V14,
      )> sequence() => record14(this);
}

extension SequenceParser15Extension<V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15> on (
  Parser<V1>,
  Parser<V2>,
  Parser<V3>,
  Parser<V4>,
  Parser<V5>,
  Parser<V6>,
  Parser<V7>,
  Parser<V8>,
  Parser<V9>,
  Parser<V10>,
  Parser<V11>,
  Parser<V12>,
  Parser<V13>,
  Parser<V14>,
  Parser<V15>,
) {
  Parser<
      (
        V1,
        V2,
        V3,
        V4,
        V5,
        V6,
        V7,
        V8,
        V9,
        V10,
        V11,
        V12,
        V13,
        V14,
        V15,
      )> sequence() => record15(this);
}
