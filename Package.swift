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
                      url: "https://github.com/ubiregiinc/LicenseList/releases/download/0.4.2/swift-packages-parser-macos.artifactbundle.zip",
                      checksum: "3e00b8b89622a33a4c2f30f5dca2d2229daf3bdf93432eea6a0d7c740cb2ff22")
    ]
)
