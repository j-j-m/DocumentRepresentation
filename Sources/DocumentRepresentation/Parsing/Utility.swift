import Parsing

let unicode = ParsePrint(.unicode) {
  Prefix(4) { $0.isHexDigit }
}

let escape = Parse {
  "\\".utf8

  OneOf {
    "\"".utf8.map { "\"" }
    "\\".utf8.map { "\\" }
    "/".utf8.map { "/" }
    "b".utf8.map { "\u{8}" }
    "f".utf8.map { "\u{c}" }
    "n".utf8.map { "\n" }
    "r".utf8.map { "\r" }
    "t".utf8.map { "\t" }
    unicode
  }
}

func isLegalCharacter(_ s: UnicodeScalar) -> Bool {
  s != "\u{fffe}" && s != "\u{ffff}"
}

extension UTF8.CodeUnit {
    var isHexDigit: Bool {
        (.init(ascii: "0") ... .init(ascii: "9")).contains(self)
        || (.init(ascii: "A") ... .init(ascii: "F")).contains(self)
        || (.init(ascii: "a") ... .init(ascii: "f")).contains(self)
    }
    
    var isUnescapedJSONStringByte: Bool {
        self != .init(ascii: "\"")
        && self != .init(ascii: "'")
        && self != .init(ascii: "\\")
        && self >= .init(ascii: " ")
    }
}

let attributeValueParser = OneOf {
    ParsePrint {
        "'".utf8
        Prefix(1...) { $0.isUnescapedJSONStringByte }.map(.string)
        "'".utf8
    }
    ParsePrint {
        "\"".utf8
        Prefix(1...) { $0.isUnescapedJSONStringByte }.map(.string)
        "\"".utf8
    }
}

//let attributeValueParser = OneOf {
//    ParsePrint {
//        "\"".utf8
//        Many(into: "") { string, fragment in
//            string.append(contentsOf: fragment)
//        } decumulator: { string in
//            string.map(String.init).reversed().makeIterator()
//        } element: {
//            OneOf {
//                Prefix(1...) { $0.isUnescapedJSONStringByte }.map(.string)
//
//                escape
//            }
//        } terminator: {
//            "\"".utf8
//        }
//    }
//    ParsePrint {
//        "\'".utf8
//        Many(into: "") { string, fragment in
//            string.append(contentsOf: fragment)
//        } decumulator: { string in
//            string.map(String.init).reversed().makeIterator()
//        } element: {
//            OneOf {
//                Prefix(1...) { $0.isUnescapedJSONStringByte }.map(.string)
//
//                escape
//            }
//        } terminator: {
//            "\'".utf8
//        }
//    }
//}
