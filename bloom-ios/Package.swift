// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Bloom",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Bloom",
            targets: ["Bloom"]
        )
    ],
    targets: [
        .target(
            name: "Bloom",
            path: "Sources/Bloom"
        ),
        .testTarget(
            name: "BloomTests",
            dependencies: ["Bloom"],
            path: "Tests/BloomTests"
        )
    ]
)
