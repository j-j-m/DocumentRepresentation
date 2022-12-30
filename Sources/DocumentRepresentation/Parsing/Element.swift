import Parsing
import Html

let paddedEqualSign = ParsePrint {
    Whitespace()
    "=".utf8
    Whitespace()
}

extension UTF8.CodeUnit {

    var notEscape: Bool {
        self != .init(ascii: "/")
        && self != .init(ascii: ">")
        && self != .init(ascii: " ")
    }
}

let name = Many(into: "") { string, fragment in
    string.append(contentsOf: fragment)
} decumulator: { string in
    string.map(String.init).reversed().makeIterator()
} element: {
    Prefix(1...) { $0.notEscape }.map(.string)
} terminator: {
    OneOf {
        Whitespace()
        "".utf8
        "/>".utf8
    }
}

let attribute = ParsePrint {
    name
    paddedEqualSign
    Optionally {
        attributeValueParser
    }
}

let attributes = Many {
    attribute
} separator: {
    Whitespace()
}

let startTag = ParsePrint {
    "<".utf8
    name
    Whitespace()
    attributes
    ">".utf8
}

let endTag = ParsePrint {
    "</".utf8
    name
    ">".utf8
}

let selfClosingTag = ParsePrint {
    "<".utf8
    name
    attributes
    "/>".utf8
}

let emptyTag = ParsePrint {
    startTag
    endTag
}
    .filter { open, _, close in open == close }
    .map(
        .convert(
            apply: {
                ($0.0, $0.1)
            },
            unapply: {
                ($0.0, $0.1, $0.0)
            }
        )
    )

let emptyElementParser = ParsePrint {
    OneOf {
        emptyTag
        selfClosingTag
    }
    .map(
        .convert(
            apply: { name, attributes in
                Node.element(name, attributes, Node.fragment([]))
            },
            unapply: { node in
                switch node {
                case let Node.element(name, attributes, _):
                    return (name, attributes)
                default:
                    return nil
                }
            }
        )
    )
}

let textElementParser = ParsePrint {
    startTag
    ParsePrint(.toString) {
        PrefixUpTo("</".utf8)
    }
    endTag
}
    .filter { open, _, _, close in open == close }
    .map(
        .convert(
            apply: { name, attributes, text, _ in
                Node.element(
                    name,
                    attributes,
                    name == "title"
                        ? .fragment([.raw(text)])
                    : .fragment([.text(text)])
                )
            },
            unapply: { node in
                switch node {
                case let Node.element(name, attributes, .text(text)):
                    return (name, attributes, text, name)
                default:
                    return nil
                }
            }
        )
    )

let nonEmptyElementParser: AnyParserPrinter<Substring.UTF8View, Node> = ParsePrint {
    startTag
    Many {
        OneOf {
            commentParser
            emptyElementParser
            textElementParser
            Lazy {
                nonEmptyElementParser
            }
        }
    }
    endTag
}
    .filter { open, _, _, close in open == close }
    .map(
        .convert(
            apply: { (name, attributes, content, endName) in
                Node.element(name, attributes, Node.fragment(content))
            },
            unapply: { node in
                switch node {
                case let Node.element(name, attributes, content):
                    return (name, attributes, [content], name)
                default:
                    return nil
                }
            }
        )
    )
    .eraseToAnyParserPrinter()

