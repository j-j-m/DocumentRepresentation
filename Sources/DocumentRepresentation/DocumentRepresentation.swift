import Parsing
import Html

public struct DocumentRepresentation {

    internal let rawString: String
    public let model: Node

    public init(html: String) throws {
        self.rawString = html

        var input = html[...].utf8
        model = try htmlParser.parse(&input)
    }
}
