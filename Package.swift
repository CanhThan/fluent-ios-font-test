// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "FontProbe",
    platforms: [.iOS(.v17)],
    products: [.library(name: "FontProbe", targets: ["FontProbe"])],
    dependencies: [
        .package(url: "https://github.com/microsoft/fluentui-apple.git",
                 revision: "920ee25179c4d2086aa1219b106be90d5ab37113")
    ],
    targets: [
        .target(name: "FontProbe",
                dependencies: [.product(name: "FluentUI", package: "fluentui-apple")]),
        .testTarget(name: "FontProbeTests",
                    dependencies: ["FontProbe"],
                    resources: [.copy("Fonts")])
    ]
)