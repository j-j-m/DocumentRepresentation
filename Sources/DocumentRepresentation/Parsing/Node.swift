import Parsing
import Html

///// The basic unit of an HTML tree.
//public enum Node {
//  /// Represents a renderable comment.
//  case comment(String)
//
//  /// Represents an HTML DOCTYPE.
//  case doctype(String)
//
//  /// Represents an element node with a tag name, an array of attributes, and an array of child nodes.
//  indirect case element(String, [(key: String, value: String?)], Node)
//
//  /// Represents an array of nodes.
//  case fragment([Node])
//
//  /// An unsafe escape hatch: represents raw text that should not be escaped by a renderer.
//  case raw(String)
//
//  /// Represents a text node that can be escaped when rendered.
//  case text(String)
//}

let elementParser = ParsePrint(.toString) {
  "<!--".utf8
    PrefixUpTo("-->".utf8)
  "-->".utf8
}
    .map(.case(Node.comment))

// MARK: - Document Parser
public typealias DocumentParser = AnyParserPrinter<Substring.UTF8View, Node>

public let htmlParser: DocumentParser =
ParsePrint {
    Many {
        OneOf {
            doctypeParser
            commentParser
            emptyElementParser
            nonEmptyElementParser
        }
    }
    .map(
        .convert(
            apply: {
                Node.fragment($0)
            },
            unapply: { node in
                switch node {
                case let Node.fragment(nodes):
                    return nodes
                default:
                    return nil
                }
            })
    )
}
.eraseToAnyParserPrinter()
