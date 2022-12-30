import XCTest
@testable import DocumentRepresentation

final class DoctypeParserTests: XCTestCase {
    func testParse() throws {

        let sample = "<!DOCTYPE html>"
        var input = sample[...].utf8
        let model = try doctypeParser.parse(&input)

        XCTAssertEqual(model, .doctype("html"))
    }

    func testPrint() throws {

        var output: Substring.UTF8View = .init()
        try doctypeParser.print(.doctype("html"), into: &output)

        XCTAssertEqual(String(Substring(output)), "<!DOCTYPE html>")

    }
}
