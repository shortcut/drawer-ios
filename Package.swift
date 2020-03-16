// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Drawer",
    platforms: [.iOS("11.0")],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Drawer",
            targets: ["Drawer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Drawer",
            dependencies: [],
            path: "Sources/Drawer"),
        .testTarget(
            name: "DrawerTests",
            dependencies: ["Drawer"],
            path: "Tests/DrawerTests"),
    ]
)
