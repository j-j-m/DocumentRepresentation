import XCTest
@testable import DocumentRepresentation
import Html

final class NonEmptyElementParserTests: XCTestCase {
    func testParseNesting() throws {

        let sample = #"<dummy><idiot><fool></fool><twit></twit></idiot></dummy>"#
        var input = sample[...].utf8
        let model = try nonEmptyElementParser.parse(&input)

        XCTAssertEqual(
            model,
            .element(
                "dummy",
                [],
                .fragment([
                    .element(
                        "idiot",
                        [],
                        .fragment([
                            .element(
                                "fool",
                                [],
                                .fragment([])
                            ),
                            .element(
                                "twit",
                                [],
                                .fragment([])
                            )
                        ])
                    )
                ])
            )
        )
    }

    func testParseMoreNesting() throws {

        let sample = #"<html><body><div><p>paragraph</p></div></body></html>"#
        var input = sample[...].utf8
        let model = try nonEmptyElementParser.parse(&input)

        XCTAssertEqual(
            model,
            .element(
                "html",
                [],
                .fragment([
                    .element(
                        "body",
                        [],
                        .fragment([
                            .element(
                                "div",
                                [],
                                .fragment([
                                    .element(
                                        "p",
                                        [],
                                        .fragment([
                                            .text("paragraph")
                                        ])
                                    )
                                ])
                            )
                        ])
                    )
                ])
            )
        )
    }
}
