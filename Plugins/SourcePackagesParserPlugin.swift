import Foundation
import PackagePlugin

@main
struct SourcePackagesParserPlugin: CommandPlugin {
    // Entry point for command plugins applied to Swift Packages.
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        try exec(context: context, arguments: arguments)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SourcePackagesParserPlugin: XcodeCommandPlugin {
    // Entry point for command plugins applied to Xcode projects.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try exec(context: context, arguments: arguments)
    }
}

#endif

extension SourcePackagesParserPlugin {
    private func exec(context: some Context, arguments: [String]) throws {
        let process = Process()
        process.currentDirectoryURL = context.workingDirectoryURL
        process.executableURL = try context.tool(named: "spp").url
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()

        switch process.terminationReason {
        case .exit:
            break
        case .uncaughtSignal:
            Diagnostics.error("Got uncaught signal while running")
        @unknown default:
            Diagnostics.error("Stopped running by unexpected termination reason \(process.terminationReason)")
        }

        if process.terminationStatus == EXIT_FAILURE {
            Diagnostics.error("Exit code \(process.terminationStatus)")
        }
    }
}

private protocol Context {
    var workingDirectoryURL: URL { get }
    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

extension PluginContext: Context {
    var workingDirectoryURL: URL {
        package.directoryURL
    }
}

#if canImport(XcodeProjectPlugin)
extension XcodePluginContext: Context {
    var workingDirectoryURL: URL {
        xcodeProject.directoryURL
    }
}
#endif
