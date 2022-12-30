// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocumentRepresentation",
    platforms: [
        .macOS(.v13),
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DocumentRepresentation",
            targets: ["DocumentRepresentation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-html", from: "0.4.0"),
        .package(url: "https://github.com/pointfreeco/swift-parsing.git", from: "0.11.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DocumentRepresentation",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing"),
                .product(name: "Html", package: "swift-html")
            ]
        ),
        .testTarget(
            name: "DocumentRepresentationTests",
            dependencies: ["DocumentRepresentation"]),
    ]
)
