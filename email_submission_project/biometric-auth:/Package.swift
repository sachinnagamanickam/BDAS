// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BiometricAuthServer",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "BiometricAuthServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]
        )
    ]
)
