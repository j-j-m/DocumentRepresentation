import XCTest
@testable import DocumentRepresentation
import Html

final class AttributeValueParserTests: XCTestCase {

    func testParseSingleQuote() throws {

        let sample = #"'singleQuote'"#
        var input = sample[...].utf8
        let subject = try attributeValueParser.parse(&input)

        XCTAssertEqual(subject, "singleQuote")
    }

    func testParseDoubleQuote() throws {

        let sample = #""doubleQuote""#
        var input = sample[...].utf8
        let subject = try attributeValueParser.parse(&input)

        XCTAssertEqual(subject, "doubleQuote")
    }

    func testPrint() throws {

        var output: Substring.UTF8View = .init()
        try attributeValueParser.print(
            "doubleQuote",
            into: &output
        )

        XCTAssertEqual(
            String(Substring(output)),
            #""doubleQuote""#
        )
    }
}
