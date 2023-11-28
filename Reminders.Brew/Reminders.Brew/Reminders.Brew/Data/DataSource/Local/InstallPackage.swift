//
//  InstallPackage.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import Foundation
import SwiftUI
import Reminders_Domain

//@MainActor
func installPackage(installationProgressTracker: InstallationProgressTracker) async throws -> TerminalOutput {
    let showRealTimeTerminalOutputs = UserDefaults.standard.bool(forKey: "showRealTimeTerminalOutputOfOperations")
    AppLogger.homeBrew.log("Installing package \(installationProgressTracker.packagesBeingInstalled[0].package.name)")
    var installationResult = TerminalOutput(standardOutput: "", standardError: "")
    /// For some reason, the line `fetching [package name]` appears twice during the matching process, and the first one is a dud. Ignore that first one.
    var hasAlreadyMatchedLineAboutInstallingPackageItself: Bool = false
    var packageDependencies: [String] = .init()
    if !installationProgressTracker.packagesBeingInstalled[0].package.isCask {
        AppLogger.homeBrew.log("Package is Formula")
        //if let _ = BrewService.shared.brewReadyForAsyncStream() {
            for await output in brew(["install", installationProgressTracker.packagesBeingInstalled[0].package.name]) {
                switch output {
                case let .standardOutput(outputLine):
                    AppLogger.homeBrew.log("Line out: \(outputLine)")
                    if showRealTimeTerminalOutputs {
                        installationProgressTracker.packagesBeingInstalled[0].realTimeTerminalOutput.append(RealTimeTerminalLine(line: outputLine))
                    }
                    AppLogger.homeBrew.log("Does the line contain an element from the array? \(outputLine.containsElementFromArray(packageDependencies))")
                    if outputLine.contains("Fetching dependencies") {
                        // First, we have to get a list of all the dependencies
                        let dependencyMatchingRegex: String = "(?<=\(installationProgressTracker.packagesBeingInstalled[0].package.name): ).*?(.*)"
                        var matchedDependencies = try regexMatch(from: outputLine, regex: dependencyMatchingRegex)
                        matchedDependencies = matchedDependencies.replacingOccurrences(of: " and", with: ",") // The last dependency is different, because it's preceded by "and" instead of "," so let's replace that "and" with "," so we can split it nicely
                        AppLogger.homeBrew.log("Matched Dependencies: \(matchedDependencies)")
                        packageDependencies = matchedDependencies.components(separatedBy: ", ") // Make the dependency list into an array
                        AppLogger.homeBrew.log("Package Dependencies: \(packageDependencies)")
                        AppLogger.homeBrew.log("Will fetch \(packageDependencies.count) dependencies!")
                        installationProgressTracker.numberOfPackageDependencies = packageDependencies.count // Assign the number of dependencies to the tracker for the user to see
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = 1
                    } else if outputLine.contains("Installing dependencies") || outputLine.contains("Installing \(installationProgressTracker.packagesBeingInstalled[0].package.name) dependency") {
                        AppLogger.homeBrew.log("Will install dependencies!")
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .installingDependencies
                        // Increment by 1 for each package that finished installing
                        installationProgressTracker.numberInLineOfPackageCurrentlyBeingInstalled = installationProgressTracker.numberInLineOfPackageCurrentlyBeingInstalled + 1
                        AppLogger.homeBrew.log("Installing dependency \(installationProgressTracker.numberInLineOfPackageCurrentlyBeingInstalled) of \(packageDependencies.count)")
                        // TODO: Add a math formula for advancing the stepper
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress + Double(Double(10) / (Double(3) * Double(installationProgressTracker.numberOfPackageDependencies)))
                    } else if outputLine.contains("Already downloaded") || (outputLine.contains("Fetching") && outputLine.containsElementFromArray(packageDependencies)) {
                        AppLogger.homeBrew.log("Will fetch dependencies!")
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .fetchingDependencies
                        installationProgressTracker.numberInLineOfPackageCurrentlyBeingFetched = installationProgressTracker.numberInLineOfPackageCurrentlyBeingFetched + 1
                        AppLogger.homeBrew.log("Fetching dependency \(installationProgressTracker.numberInLineOfPackageCurrentlyBeingFetched) of \(packageDependencies.count)")
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress + Double(Double(10) / (Double(3) * (Double(installationProgressTracker.numberOfPackageDependencies) * Double(5))))
                    } else if outputLine.contains("Fetching \(installationProgressTracker.packagesBeingInstalled[0].package.name)") || outputLine.contains("Installing \(installationProgressTracker.packagesBeingInstalled[0].package.name)") {
                        if hasAlreadyMatchedLineAboutInstallingPackageItself { /// Only the second line about the package being installed is valid
                            AppLogger.homeBrew.log("Will install the package itself!")
                            installationProgressTracker.packagesBeingInstalled[0].installationStage = .installingPackage
                            // TODO: Add a math formula for advancing the stepper
                            installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = Double(installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress) + Double((Double(10) - Double(installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress)) / Double(2))
                            AppLogger.homeBrew.log("Stepper value: \(Double(Double(10) / (Double(3) * Double(installationProgressTracker.numberOfPackageDependencies))))")
                        } else { /// When it appears for the first time, ignore it
                            AppLogger.homeBrew.log("Matched the dud line about the package itself being installed!")
                            hasAlreadyMatchedLineAboutInstallingPackageItself = true
                            installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = Double(installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress) + Double((Double(10) - Double(installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress)) / Double(2))
                        }
                    }
                    installationResult.standardOutput.append(outputLine)
                    AppLogger.homeBrew.log("Current installation stage: \(installationProgressTracker.packagesBeingInstalled[0].installationStage)")
                case let .standardError(errorLine):
                    AppLogger.homeBrew.log("Errored out: \(errorLine)")
                    if showRealTimeTerminalOutputs {
                        installationProgressTracker.packagesBeingInstalled[0].realTimeTerminalOutput.append(RealTimeTerminalLine(line: errorLine))
                    }
                    if errorLine.contains("a password is required") {
                        AppLogger.homeBrew.log("Install requires sudo")
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .requiresSudoPassword
                    }
                }
            }
        //}
        //BrewService.shared.brewTerminate()
        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = 10
        installationProgressTracker.packagesBeingInstalled[0].installationStage = .finished
    } else {
        AppLogger.homeBrew.log("Package is Cask")
        AppLogger.homeBrew.log("Installing package \(installationProgressTracker.packagesBeingInstalled[0].package.name)")
        //if let _ = BrewService.shared.brewReadyForAsyncStream() {
            for await output in brew(["install", "--no-quarantine", installationProgressTracker.packagesBeingInstalled[0].package.name]) {
                switch output {
                case let .standardOutput(outputLine):
                    AppLogger.homeBrew.log("Output line: \(outputLine)")
                    if showRealTimeTerminalOutputs {
                        installationProgressTracker.packagesBeingInstalled[0].realTimeTerminalOutput.append(RealTimeTerminalLine(line: outputLine))
                    }
                    if outputLine.contains("Downloading") {
                        AppLogger.homeBrew.log("Will download Cask")
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress + 2
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .downloadingCask
                    } else if outputLine.contains("Installing Cask") {
                        AppLogger.homeBrew.log("Will install Cask")
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress + 2
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .installingCask
                    } else if outputLine.contains("Moving App") {
                        AppLogger.homeBrew.log("Moving App")
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress + 2
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .movingCask
                    } else if outputLine.contains("Linking binary") {
                        AppLogger.homeBrew.log("Linking Binary")
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress + 2
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .linkingCaskBinary
                    } else if outputLine.contains("was successfully installed") {
                        AppLogger.homeBrew.log("Finished installing app")
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .finished
                        installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress = 10
                    }
                case let .standardError(errorLine):
                    AppLogger.homeBrew.log("Line had error: \(errorLine)")
                    if showRealTimeTerminalOutputs {
                        installationProgressTracker.packagesBeingInstalled[0].realTimeTerminalOutput.append(RealTimeTerminalLine(line: errorLine))
                    }
                    if errorLine.contains("a password is required") {
                        AppLogger.homeBrew.log("Install requires sudo")
                        installationProgressTracker.packagesBeingInstalled[0].installationStage = .requiresSudoPassword
                    }
                }
            }
            //BrewService.shared.brewTerminate()
        }
    //}
    //await synchronizeInstalledPackages(brewData: brewData)
    return installationResult
}

/*@MainActor
func synchronizeInstalledPackages(brewData: BrewDataStorage) async -> Void {
    let dummyAppState: AppState = AppState()
    dummyAppState.isLoadingFormulae = false
    dummyAppState.isLoadingCasks = false
    /// These have to use this dummy AppState, which forces them to not activate the "loading" animation. We don't want the entire thing to re-draw
    let newFormulae: Set<BrewPackage> = await loadUpPackages(whatToLoad: .formula, appState: dummyAppState)
    let newCasks: Set<BrewPackage> = await loadUpPackages(whatToLoad: .cask, appState: dummyAppState)
    if newFormulae.count != brewData.installedFormulae.count {
        withAnimation {
            brewData.installedFormulae = newFormulae
        }
    }
    if newCasks.count != brewData.installedCasks.count {
        withAnimation {
            brewData.installedCasks = newCasks
        }
    }
}*/

