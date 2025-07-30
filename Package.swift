// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SourcePackagesParserPlugin",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .plugin(
            name: "SourcePackagesParserPlugin",
            targets: ["SourcePackagesParserPlugin"]),
    ],
    targets: [
        .plugin(
            name: "SourcePackagesParserPlugin",
            capability: .command(
                intent: .custom(verb: "spp", description: "Source Package Parser"),
                permissions: [
                    .writeToPackageDirectory(reason: "output license files.")
                ]
            ),
            dependencies: [.target(name: "swift-packages-parser")]
        ),
        .binaryTarget(name: "swift-packages-parser",
                      url: "https://github.com/ubiregiinc/LicenseList/releases/download/0.4.3/swift-packages-parser-macos.artifactbundle.zip",
                      checksum: "d47f077c7094ecdd2bea78fbaf73f9ba913b8b69b0f640af86a73b362a8c3076")
    ]
)
