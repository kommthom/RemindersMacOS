//
//  Shell Interface.swift
//  Cork
//
//  Created by David Bureš on 03.07.2022.
//

import Foundation
import Reminders_Domain

@discardableResult
func brew(
    launchPath: URL = HomeBrewConstants.brewExecutablePath,
    _ arguments: [String],
    environment: [String: String]? = nil
) async -> TerminalOutput {
    var allOutput: [String] = .init()
    var allErrors: [String] = .init()
    for await streamedOutput in brew(arguments, environment: environment) {
        switch streamedOutput {
        case let .standardOutput(output):
            allOutput.append(output)
        case let .standardError(error):
            allErrors.append(error)
        }
    }
    return .init(
        standardOutput: allOutput.joined(),
        standardError: allErrors.joined()
    )
}


/// # Usage:
/// for await output in shell(AppConstants.brewExecutablePath, ["install", package.name])
/// {
///    switch output
///    {
///    case let .output(outputLine):
///        // Do something with `outputLine`
///    case let .error(errorLine):
///        // Do something with `errorLine`
///    }
///}
func brew(
    launchPath: URL = HomeBrewConstants.brewExecutablePath,
    _ arguments: [String],
    environment: [String: String]? = nil
) -> AsyncStream<StreamedTerminalOutput> {
    let task = Process()
    var finalEnvironment: [String: String] = .init()
    
    // MARK: - Set up the $HOME environment variable so brew commands work on versions 4.1 and up
    // var environment = ProcessInfo.processInfo.environment
    
    if var environment {
        environment["HOME"] = FileManager.default.homeDirectoryForCurrentUser.path //FileManagerService.shared.homeDirectoryForCurrentUser.path
        //environment["PATH"] = "/opt/homebrew/bin"
        finalEnvironment = environment
    } else {
        finalEnvironment = ["HOME": FileManager.default.homeDirectoryForCurrentUser.path] //FileManagerService.shared.homeDirectoryForCurrentUser.path]
        //finalEnvironment["PATH"] = "/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin"
    }
    
    // MARK: - Set up proxy if it's enabled
    if let proxySettings = HomeBrewConstants.proxySettings {
        AppLogger.homeBrew.log("Proxy is enabled")
        finalEnvironment["ALL_PROXY"] = "\(proxySettings.host):\(proxySettings.port)"
    } else {
        AppLogger.homeBrew.log("Proxy is not enabled")
    }
    task.environment = finalEnvironment
    //if launchPath.isFileURL {
        task.launchPath = launchPath.absoluteString //.executableURL = launchPath
        task.arguments = arguments
    /*} else {
        AppLogger.homeBrew.log(level: .error, "launchPath (\(launchPath)) contains no executable file")
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        var argumentsArray: [String] = ["-c", launchPath.absoluteString]
        for argument in arguments {
            argumentsArray.append(argument)
        }*/
        AppLogger.homeBrew.log("shell arguments: \(arguments.joined(separator: ", "))")
        /*task.arguments = argumentsArray
    }*/
    let pipe = Pipe()
    task.standardOutput = pipe
    let errorPipe = Pipe()
    task.standardError = errorPipe
    do {
        try task.run()
    } catch {
        AppLogger.homeBrew.log(error.localizedDescription)
    }
    return AsyncStream { continuation in
        pipe.fileHandleForReading.readabilityHandler = { handler in
            guard let standardOutput = String(data: handler.availableData, encoding: .utf8) else {
                return
            }
            guard !standardOutput.isEmpty else { return }
            continuation.yield(.standardOutput(standardOutput))
        }
        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            guard let errorOutput = String(data: handler.availableData, encoding: .utf8) else {
                return
            }
            guard !errorOutput.isEmpty else { return }
            continuation.yield(.standardError(errorOutput))
        }
        task.terminationHandler = { _ in
            continuation.finish()
        }
    }
}
