// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineAsync",
    platforms: [.macOS("10.15"), .iOS("13.0"), .tvOS("13.0"), .watchOS("6.0")],
    products: [
        .library(name: "CombineAsync", targets: ["CombineAsync"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "CombineAsync", dependencies: []),
        .testTarget(name: "CombineAsyncTests", dependencies: ["CombineAsync"]),
    ],
    swiftLanguageVersions: [.v5]
)
