import XCTest
@testable import DocumentRepresentation

final class CommentParserTests: XCTestCase {
    func testParse() throws {

        let sample = "<!-- this is a comment -->"
        var input = sample[...].utf8
        let model = try commentParser.parse(&input)

        XCTAssertEqual(model, .comment(" this is a comment "))
    }

    func testPrint() throws {

        var output: Substring.UTF8View = .init()
        try commentParser.print(.comment("a comment to be printed"), into: &output)

        XCTAssertEqual(
            String(Substring(output)),
            "<!--a comment to be printed-->"
        )
    }
}
