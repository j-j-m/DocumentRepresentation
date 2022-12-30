import XCTest
@testable import DocumentRepresentation
import Html

final class DocumentRepresentationTests: XCTestCase {
    func testExample() throws {

        //        let sample =
        //"""
        //<!DOCTYPE html>
        //<html>
        //  <head>
        //    <title>This is a title</title>
        //  </head>
        //  <body>
        //    <div>
        //        <p>Hello world!</p>
        //    </div>
        //  </body>
        //</html>
        //"""

        let sample =
"""
<!DOCTYPE html><html><head><title>title</title></head><body><div><p>paragraph</p></div></body></html>
"""
        let doc = try DocumentRepresentation(html: sample)

        XCTAssertEqual(
            doc.model,
            .fragment([
                .doctype("html"),
                .element(
                    "html",
                    [],
                    .fragment([
                        .element(
                            "head",
                            [],
                            .fragment([
                                .element(
                                    "title",
                                    [],
                                    .fragment([
                                        .raw("title")
                                    ])
                                )
                            ])
                        ),
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
            ])
        )

    }
}
