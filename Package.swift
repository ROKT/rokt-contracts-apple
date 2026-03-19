// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RoktContracts",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        .library(name: "RoktContracts", targets: ["RoktContracts"])
    ],
    targets: [
        .target(
            name: "RoktContracts",
            path: "Sources/RoktContracts"
        ),
        .testTarget(
            name: "RoktContractsTests",
            dependencies: ["RoktContracts"],
            path: "Tests/RoktContractsTests"
        )
    ]
)
