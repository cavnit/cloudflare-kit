// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "cloudflare-kit",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "CloudflareKit",
            targets: ["CloudflareKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
    ],
    targets: [
        .target(
            name: "CloudflareKit",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        .testTarget(
            name: "CloudflareKitTests",
            dependencies: ["CloudflareKit"]
        ),
    ]
)
