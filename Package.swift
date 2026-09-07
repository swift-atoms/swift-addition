// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-addition",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Addition", targets: ["Addition"]),
        .library(name: "Addition Standard Library Integration", targets: ["Addition Standard Library Integration"]),
        .library(name: "Addition Foundation Library Integration", targets: ["Addition Foundation Library Integration"]),
        .library(name: "Addition Test Support", targets: ["Addition Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-polarity.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Addition",
            dependencies: [
                .product(name: "Polarity", package: "swift-polarity"),
            ],
            path: "Sources/Addition"
        ),
        .target(
            name: "Addition Standard Library Integration",
            dependencies: [
                .target(name: "Addition"),
            ],
            path: "Sources/Addition Standard Library Integration"
        ),
        .target(
            name: "Addition Foundation Library Integration",
            dependencies: [
                .target(name: "Addition"),
                .target(name: "Addition Standard Library Integration"),
            ],
            path: "Sources/Addition Foundation Library Integration"
        ),
        .target(
            name: "Addition Test Support",
            dependencies: [
                .target(name: "Addition"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Addition Tests",
            dependencies: [
                .target(name: "Addition"),
                .product(name: "Polarity", package: "swift-polarity"),
                .target(name: "Addition Test Support"),
                .target(name: "Addition Standard Library Integration"),
                .target(name: "Addition Foundation Library Integration"),
            ],
            path: "Tests/Addition Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
