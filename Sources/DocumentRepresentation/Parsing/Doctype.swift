import Parsing
import Html

let doctypeParser = ParsePrint(.toString) {
    "<!DOCTYPE ".utf8
    Whitespace()
    PrefixUpTo(">".utf8)
    ">".utf8
}
    .map(.case(Node.doctype))
