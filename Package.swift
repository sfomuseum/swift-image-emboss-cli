// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "image-emboss",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/sfomuseum/swift-image-emboss", from: "0.0.5"),
        // .package(path: "/usr/local/sfomuseum/swift-image-emboss"),
        .package(url: "https://github.com/sfomuseum/swift-coreimage-image.git", from: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "image-emboss",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ImageEmboss", package: "swift-image-emboss"),
                .product(name:"CoreImageImage", package: "swift-coreimage-image")
            ],
            path: "Sources"),
    ]
)
