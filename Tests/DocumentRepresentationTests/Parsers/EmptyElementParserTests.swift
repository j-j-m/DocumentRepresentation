import XCTest
@testable import DocumentRepresentation
import Html

final class EmptyElementParserTests: XCTestCase {
    func testParseSelfClosing() throws {

        let sample = #"<dummy />"#
        var input = sample[...].utf8
        let model = try emptyElementParser.parse(&input)

        if case let .element(name, attributes, content) = model {
            XCTAssertEqual(name, "dummy")
            XCTAssertEqual(attributes.count, 0)
        } else {
            XCTFail()
        }
    }

    func testParseSelfClosingWithAttributes() throws {

        let sample = #"<dummy id = "test-dummy"/>"#
        var input = sample[...].utf8
        let model = try emptyElementParser.parse(&input)

        if case let .element(name, attributes, content) = model {
            XCTAssertEqual(name, "dummy")
            XCTAssertEqual(attributes.count, 1)
            XCTAssertEqual(attributes.first?.0, "id")
            XCTAssertEqual(attributes.first?.1, "test-dummy")
            XCTAssertEqual(content, .fragment([]))
        } else {
            XCTFail()
        }
    }

    func testParseEmpty() throws {

        let sample = #"<dummy></dummy>"#
        var input = sample[...].utf8
        let model = try emptyElementParser.parse(&input)

        if case let .element(name, attributes, content) = model {
            XCTAssertEqual(name, "dummy")
            XCTAssertEqual(attributes.count, 0)
        } else {
            XCTFail()
        }
    }

    func testParseEmptyWithAttributes() throws {

        let sample = #"<dummy id = "test-dummy"></dummy>"#
        var input = sample[...].utf8
        let model = try emptyElementParser.parse(&input)

        if case let .element(name, attributes, content) = model {
            XCTAssertEqual(name, "dummy")
            XCTAssertEqual(attributes.count, 1)
            XCTAssertEqual(attributes.first?.0, "id")
            XCTAssertEqual(attributes.first?.1, "test-dummy")
            XCTAssertEqual(content, .fragment([]))
        } else {
            XCTFail()
        }
    }

    func testPrint() throws {

        var output: Substring.UTF8View = .init()
        try emptyElementParser.print(
            Node.element("dummy", [("id", "test-dummy")], .fragment([])),
            into: &output
        )

        XCTAssertEqual(
            String(Substring(output)),
            "<!--a comment to be printed-->"
        )
    }
}
