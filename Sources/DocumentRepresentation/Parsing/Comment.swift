import Parsing
import Html

let commentParser = ParsePrint(.toString) {
  "<!--".utf8
    PrefixUpTo("-->".utf8)
  "-->".utf8
}
    .map(.case(Node.comment))
