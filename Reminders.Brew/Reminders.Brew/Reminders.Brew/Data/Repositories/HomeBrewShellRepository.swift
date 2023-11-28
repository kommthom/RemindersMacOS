//
//  HomeBrewShellRepository.swift
//  RemindersMacOS
//
//  Created by Thomas on 12.10.23.
//

import Foundation
import Combine
import SwiftyJSON
import Reminders_Domain

public struct DefaultHomeBrewShellRepository: HomeBrewShellRepositoryProtocol {
    @MainActor
    public func hasLoadedHomeBrewFormulae() -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to hasLoadedHomeBrewFormulae()")
        return hasHomeBrewPackages(packageType: PackageType.formula)
    }
    
    @MainActor
    public func hasLoadedHomeBrewCasks() -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to hasLoadedHomeBrewCasks()")
        return hasHomeBrewPackages(packageType: PackageType.cask)
    }
    
    @MainActor
    public func hasLoadedHomeBrewTaps() -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to hasLoadedHomeBrewTaps()")
            return hasHomeBrewPackages(packageType: PackageType.tap)
    }
    
    @MainActor
    public func homeBrewFormulae() -> AnyPublisher<[BrewPackage], Error> {
        AppLogger.homeBrew.log("Call to homeBrewFormulae()")
        return getPackagesOfFolder(packageType: PackageType.formula)
    }
    
    @MainActor
    public func homeBrewCasks() -> AnyPublisher<[BrewPackage], Error> {
        AppLogger.homeBrew.log("Call to homeBrewCasks()")
        return getPackagesOfFolder(packageType: PackageType.cask)
    }
    
    @MainActor
    public func homeBrewTaps() -> AnyPublisher<[BrewTap], Error> {
        AppLogger.homeBrew.log("Call to homeBrewTaps()")
        return Just(getTapsOfFolder(packageType: PackageType.tap))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    //@MainActor
    public func uninstallPackage(packageName: String, shouldRemoveAllAssociatedFiles: Bool) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to uninstallPackage()")
        let wasUninstallSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasUninstallSuccessful
            .filter { $0 }
            .asyncMap { _ in
                var commandArray = ["uninstall", packageName]
                if shouldRemoveAllAssociatedFiles {
                    commandArray = ["uninstall", "--zap", packageName]
                }
                let uninstallResult = await brew(commandArray).standardError
                if !uninstallResult.contains("because it is required by") {
                    return true
                } else {
                    do {
                        let dependencyName = String(try regexMatch(from: uninstallResult, regex: "(?<=required by ).*?(?=, which)"))
                        throw ShellOutputError.uninstallationNotPossibleDueToDependency(packageName: packageName, dependencyName: dependencyName)
                    } catch let regexError as NSError {
                        AppLogger.homeBrew.log(level: .error, "Failed to extract dependency name from output: \(regexError)")
                        throw RegexError.foundNilRange
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func uninstallTap(tapName: String) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to uninstallTap()")
        let wasUninstallSuccessful = CurrentValueSubject<Bool, Error>(false)
        return wasUninstallSuccessful
            .filter { $0 }
            .asyncMap { _ in
                let untapResult = await brew(["untap", tapName]).standardError
                if untapResult.contains("Untapped") {
                    return true
                } else {
                    throw ShellOutputError.couldNotUntap(name: tapName, errorOutput: untapResult)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func pinAndUnpinPackage(packageName: String, pinned: Bool) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to pinAndUnpinPackage()")
        let action = pinned ? "unpin" : "pin"
        let wasPinSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasPinSuccessful
            .filter { $0 }
            .asyncMap { _ in
                let result = await brew([action, packageName]).standardError
                if result.isEmpty {
                    return true
                } else {
                    throw ShellOutputError.couldNotPinUnPin(name: "\(action) \(packageName)", errorOutput: result)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func getTapInfo(tapName: String) -> AnyPublisher<BrewTapInfo, Error> {
        AppLogger.homeBrew.log("Call to getTapInfo()")
        //Task(priority: .userInitiated) {
        let successful = CurrentValueSubject<Bool, Error>(true)
        return successful
            .filter { $0 }
            .asyncMap { _ in
                let tapInfo = await brew(["tap-info", "--json", tapName]).standardOutput
                let parsedJSON = try JSON(data: tapInfo.data(using: .utf8, allowLossyConversion: false)!)
                return getTapInfoFromJSON(parsedJSON: parsedJSON, tapName: tapName)
            }
            .eraseToAnyPublisher()
    }
    
    private func getTapInfoFromJSON(parsedJSON: JSON, tapName: String) -> BrewTapInfo {
        AppLogger.homeBrew.log("Call to getTapInfoFromJSON()")
        let homePage = URL(string: parsedJSON[0, "remote"].stringValue)!
        let isOfficial = parsedJSON[0, "official"].boolValue
        var availableFormulae: [String]? = nil
        for availableFormula in parsedJSON[0, "formula_names"].arrayValue {
            if availableFormulae == nil {
                availableFormulae = [availableFormula.stringValue.replacingOccurrences(of: "\(tapName)/", with: "")]
            } else {
                availableFormulae?.append(availableFormula.stringValue.replacingOccurrences(of: "\(tapName)/", with: ""))
            }
        }
        var availableCasks: [String]? = nil
        for availableCask in parsedJSON[0, "cask_tokens"].arrayValue {
            if availableCasks == nil {
                availableCasks = [availableCask.stringValue.replacingOccurrences(of: "\(tapName)/", with: "")]
            } else {
                availableCasks?.append(availableCask.stringValue.replacingOccurrences(of: "\(tapName)/", with: ""))
            }
        }
        let numberOfPackages = Int(availableFormulae?.count ?? 0) + Int(availableCasks?.count ?? 0)
        AppLogger.homeBrew.log("Call to getTapInfoFromJSON() finished")
        return BrewTapInfo(homePage: homePage, isOfficial: isOfficial, availableFormulae: availableFormulae, availableCasks: availableCasks, numberOfPackages: numberOfPackages)
        
    }
    
    public func getPackageInfo(packageName: String, isCask: Bool) -> AnyPublisher<BrewPackageInfo, Error> {
        AppLogger.homeBrew.log("Call to getPackageInfo()")
        let successful = CurrentValueSubject<Bool, Error>(true)
        return successful
            .filter { $0 }
            .asyncMap { _ in
                var commandArray = ["info", "--json=v2", "--cask", packageName]
                if !isCask {
                    commandArray = ["info", "--json=v2", packageName]
                }
                AppLogger.homeBrew.log("getPackageInfo commandArgs: \(commandArray.joined(separator: ", "))")
                let selectedPackageInfo = await brew(commandArray).standardOutput
                AppLogger.homeBrew.log("getPackageInfo stdOut: \(selectedPackageInfo)")
                let json = try JSON(data: selectedPackageInfo.data(using: .utf8, allowLossyConversion: false)!)
                return await getPackageInfoFromJSON(json: json, packageName: packageName, isCask: isCask)
            }
            .eraseToAnyPublisher()
    }
    
    private func getPackageInfoFromJSON(json: JSON, packageName: String, isCask: Bool) async -> BrewPackageInfo {
        AppLogger.homeBrew.log("Call to getPackageInfoFromJSON()")
        var packageType = "casks"
        if !isCask {
            packageType = "formulae"
        }
        let description = json[packageType, 0, "desc"].stringValue
        let homePage = URL(string: json[packageType, 0, "homepage"].stringValue)!
        let tap = json[packageType, 0, "tap"].stringValue
        var installedAsDependency: Bool = false
        var dependencies: [BrewPackageDependency]? = nil
        if !isCask {
            for installInfo in json["formulae", 0, "installed"].arrayValue {
                installedAsDependency = installInfo["installed_as_dependency"].boolValue
                for dependency in installInfo["runtime_dependencies"].arrayValue {
                    if dependencies == nil {
                        dependencies = [BrewPackageDependency(name: dependency["full_name"].stringValue, version: dependency["version"].stringValue, directlyDeclared: dependency["declared_directly"].boolValue)]
                    } else {
                        dependencies?.append(BrewPackageDependency(name: dependency["full_name"].stringValue, version: dependency["version"].stringValue, directlyDeclared: dependency["declared_directly"].boolValue))
                    }
                }
            }
        }
        let outdated = json[packageType, 0, "outdated"].boolValue
        let caveats = json[packageType, 0, "caveats"].stringValue
        let pinned = json[packageType, 0, "pinned"].boolValue
        var packageDependents: [String]? = nil
        if installedAsDependency {
            async let packageDependentsRaw: String = await brew(["uses", "--installed", packageName]).standardOutput
            packageDependents = await packageDependentsRaw.components(separatedBy: "\n").dropLast()
        }
        AppLogger.homeBrew.log("Call to getPackageInfoFromJSON() finished")
        return BrewPackageInfo(description: description, homePage: homePage, tap: tap, installedAsDependency: installedAsDependency, packageDependents: packageDependents, dependencies: dependencies, outdated: outdated, caveats: caveats, pinned: pinned)
    }
    
    public func outdatedPackages(brewData: BrewDataStorage) -> AnyPublisher<Set<OutdatedPackage>, Error> {
        AppLogger.homeBrew.log("Call to outdatedPackages()")
        let emptyOutdatedPackagesList = CurrentValueSubject<Bool, Error>(true)
        return emptyOutdatedPackagesList
            .filter { $0 }
            .asyncMap { _ in
                AppLogger.homeBrew.log("try await getOutdatedPackages(brewData: brewData)")
                return try await getOutdatedPackages(brewData: brewData)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func removingOrphans() -> AnyPublisher<TypeOfResult, Error> {
        AppLogger.homeBrew.log("Call to removingOrphans()")
        let wasRemoveSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasRemoveSuccessful
            .filter { $0 }
            .asyncMap { _ in
                do {
                    let terminalOutput: TerminalOutput = await brew(["autoremove"])
                    if terminalOutput.standardError.isEmpty && terminalOutput.standardOutput.isEmpty {
                        return TypeOfResult.intType(0)
                    } else if terminalOutput.standardOutput.contains("Autoremoving") {
                        guard let numberOfRemovedOrphans = try Int(regexMatch(from: terminalOutput.standardOutput, regex: "(?<=Autoremoving ).*?(?= unneeded)")) else {
                            throw OrphanRemovalError.couldNotGetNumberOfUninstalledOrphans
                        }
                        return TypeOfResult.intType(numberOfRemovedOrphans)
                    } else {
                        throw HomebrewCachePurgeError.purgingCommandFailed
                    }
                } catch let purgingCommandError {
                    AppLogger.homeBrew.log(level: .error, "Homebrew cache purging command failed: \(purgingCommandError)")
                    throw HomebrewCachePurgeError.purgingCommandFailed
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func purgeHomebrewCache() -> AnyPublisher<TypeOfResult, Error> {
        AppLogger.homeBrew.log("Call to purgeHomebrewCache()")
        let wasPurgeSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasPurgeSuccessful
            .filter { $0 }
            .asyncMap { _ in
                var packagesHoldingBackCachePurgeTracker: [String] = .init()
                let terminalOutput: TerminalOutput = await brew(["cleanup"])
                if terminalOutput.standardError.contains("Warning: Skipping") {
                    var packagesHoldingBackCachePurgeInitialArray = terminalOutput.standardError.components(separatedBy: "Warning:")
                    packagesHoldingBackCachePurgeInitialArray.removeFirst()
                    for blockingPackageRaw in packagesHoldingBackCachePurgeInitialArray {
                        guard let packageHoldingBackCachePurgeName = try? regexMatch(from: blockingPackageRaw, regex: "(?<=Skipping ).*?(?=:)") else {
                            throw HomebrewCachePurgeError.regexMatchingCouldNotMatchAnything
                        }
                        packagesHoldingBackCachePurgeTracker.append(packageHoldingBackCachePurgeName)
                    }
                }
                return TypeOfResult.stringArrayType(packagesHoldingBackCachePurgeTracker)
            }
            .eraseToAnyPublisher()
    }
    
    public func deleteCachedDownloads() -> AnyPublisher<TypeOfResult, Error> {
        AppLogger.homeBrew.log("Call to deleteCachedDownloads()")
        let wasDeleteSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasDeleteSuccessful
            .filter { $0 }
            .tryMap { _ in
                let directorySize: Int = Reminders_Brew.deleteCachedDownloads()
                return TypeOfResult.intType(directorySize)
            }
            .eraseToAnyPublisher()
    }
    
    public func performBrewHealthCheck() -> AnyPublisher<TypeOfResult, Error> {
        AppLogger.homeBrew.log("Call to performBrewHealthCheck()")
        let wasCheckSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasCheckSuccessful
            .filter { $0 }
            .asyncMap { _ in
                do {
                    async let terminalOutput = await brew(["doctor"])
                    if await !terminalOutput.standardOutput.isEmpty {
                        throw HealthCheckError.errorsThrownInStandardOutput
                    }
                    return TypeOfResult.boolType(true)
                } catch let healthCheckError as NSError {
                    AppLogger.homeBrew.log(level: .error, healthCheckError.localizedDescription)
                    return TypeOfResult.boolType(false)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func addTap(tapName: String) -> AnyPublisher<TypeOfResult, Error> {
        AppLogger.homeBrew.log("Call to addTap()")
        let wasAddSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasAddSuccessful
            .filter { $0 }
            .asyncMap { _ in
                do {
                    let terminalOutput = await brew(["tap", tapName])
                    if !terminalOutput.standardOutput.contains("Tapped") {
                        if terminalOutput.standardOutput.contains("Repository not found") {
                            throw TappingError.repositoryNotFound
                        } else {
                            throw TappingError.other
                        }
                    }
                    return TypeOfResult.boolType(true)
                } catch let healthCheckError as NSError {
                    AppLogger.homeBrew.log(level: .error, healthCheckError.localizedDescription)
                    return TypeOfResult.boolType(false)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func addPackage(packageName: String) -> AnyPublisher<TypeOfResult, Error> {
        AppLogger.homeBrew.log("Call to addPackage()")
        let wasAddSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasAddSuccessful
            .filter { $0 }
            .asyncMap { _ in
                do {
                    let terminalOutput = await brew(["tap", packageName])
                    if !terminalOutput.standardOutput.contains("Tapped") {
                        if terminalOutput.standardOutput.contains("Repository not found") {
                            throw TappingError.repositoryNotFound
                        } else {
                            throw TappingError.other
                        }
                    }
                    // Force-load the packages from the new tap
                    let _ = await brew(["update"])
                    return TypeOfResult.boolType(true)
                } catch let healthCheckError as NSError {
                    AppLogger.homeBrew.log(level: .error, healthCheckError.localizedDescription)
                    return TypeOfResult.boolType(false)
                }
            }
            .eraseToAnyPublisher()
    }

    public func searchPackages(packageName: String, isCask: Bool) -> AnyPublisher<[String], Error> {
        AppLogger.homeBrew.log("Call to searchPackages()")
        let emptySearchPackages = CurrentValueSubject<Bool, Error>(false)
        return emptySearchPackages
            .filter { $0 }
            .asyncMap { _ in
                var packageArray: [String]
                if isCask {
                    packageArray = (await brew(["search", "--casks", packageName])).standardOutput.components(separatedBy: "\n")
                } else {
                    packageArray = (await brew(["search", "--formulae", packageName])).standardOutput.components(separatedBy: "\n")
                }
                packageArray.removeLast()
                return packageArray
            }
            .eraseToAnyPublisher()
    }
    
    public func brewPackageDescription(packageName: String, isCask: Bool) -> AnyPublisher<BrewPackageDescription, Error> {
        AppLogger.homeBrew.log("Call to brewPackageDescription()")
        let emptyPackageDescription = CurrentValueSubject<Bool, Error>(true)
        return emptyPackageDescription
            .filter { $0 }
            .asyncMap { _ in
                async let descriptionRaw = await brew(["info", "--json=v2", packageName]).standardOutput
                let descriptionJSON = try await parseJSON(from: descriptionRaw)
                if isCask {
                    //throw CompatibilityCheckingError.isCask
                    return BrewPackageDescription(name: packageName, description: descriptionJSON["casks", 0, "desc"].stringValue, isCompatible: true)
                } else {
                    return BrewPackageDescription(name: packageName, description: descriptionJSON["formulae", 0, "desc"].stringValue, isCompatible: try getPackageCompatibilityFromJSON(json: descriptionJSON, isCask: isCask))
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Check if a package is compatible with a particular macOS version
    private func getPackageCompatibilityFromJSON(json: JSON, isCask: Bool) throws -> Bool {
        AppLogger.homeBrew.log("Call to updateOnePackage()")
        var checkingResult: Bool = false
        /// Retrieve macOS versions for a formula
        var availableVersions: [String] = .init()
        for version in json["formulae", 0, "bottle", "stable", "files"] {
            availableVersions.append(version.0)
        }
        for systemVersion in availableVersions {
            if systemVersion.contains(HomeBrewConstants.osVersionString.lookupName) {
                checkingResult = true
                break
            }
        }
        return checkingResult
    }

    @MainActor
    public func updateOnePackage(packageName: String, isCask: Bool) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to updateOnePackage()")
        let wasUpdateSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasUpdateSuccessful
            .filter { $0 }
            .asyncMap { _ in
                var updateCommandArguments: [String] = .init()
                if isCask {
                    updateCommandArguments = ["reinstall", "--cask", packageName]
                } else {
                    updateCommandArguments = ["reinstall", packageName]
                }
                //if let _ = BrewService.shared.brewReadyForAsyncStream() {
                    for await terminalOutput in brew(updateCommandArguments) {
                        //BrewService.shared.brewTerminate()
                        switch terminalOutput {
                        case .standardOutput(_):
                            return true
                        case let .standardError(errorLine):
                            if errorLine.contains("The post-install step did not complete successfully") {
                                return true
                            } else {
                                throw UpdatingPackageError.outputHadErrors("\(packageName): \(errorLine)")
                            }
                        }
                    }
                //}
                return false
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    public func updatablePackagesAvailable(_ updateProgressTracker: UpdateProgressTracker, outdatedPackageTracker: OutdatedPackageTracker) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to updatablePackagesAvailable()")
        let showRealTimeTerminalOutputs = UserDefaults.standard.bool(forKey: "showRealTimeTerminalOutputOfOperations")
        let hasUpdatablePackages = CurrentValueSubject<Bool, Error>(true)
        return hasUpdatablePackages
            .filter { $0 }
            .asyncMap { _ in
                //if let _ = BrewService.shared.brewReadyForAsyncStream() {
                    for await terminalOutput in brew(["update"]) {
                        switch terminalOutput {
                        case let .standardOutput(outputLine):
                            if showRealTimeTerminalOutputs {
                                updateProgressTracker.realTimeOutput.append(RealTimeTerminalLine(line: outputLine))
                            }
                            updateProgressTracker.updateProgress = updateProgressTracker.updateProgress + 0.1
                            if outdatedPackageTracker.outdatedPackages.isEmpty {
                                if outputLine.starts(with: "Already up-to-date") {
                                    AppLogger.homeBrew.log("Inside update function: No updates available")
                                    //BrewService.shared.brewTerminate()
                                    return false
                                }
                            }
                        case let .standardError(errorLine):
                            if showRealTimeTerminalOutputs {
                                updateProgressTracker.realTimeOutput.append(RealTimeTerminalLine(line: errorLine))
                            }
                            if errorLine.starts(with: "Another active Homebrew update process is already in progress") || errorLine == "Error: " || errorLine.contains("Updated [0-9]+ tap") || errorLine == "Already up-to-date" || errorLine.contains("No checksum defined") {
                                updateProgressTracker.updateProgress = updateProgressTracker.updateProgress + 0.1
                                AppLogger.homeBrew.log("Ignorable update function error: \(errorLine)")
                                //BrewService.shared.brewTerminate()
                                return false
                            } else {
                                AppLogger.homeBrew.log("Update function error: \(errorLine)")
                                updateProgressTracker.errors.append("Update error: \(errorLine)")
                            }
                        }
                    }
                    //BrewService.shared.brewTerminate()
                    updateProgressTracker.updateProgress = Float(10) / Float(2)
                //}
                return true
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    public func updatePackages(updateProgressTracker: UpdateProgressTracker, detailStage: UpdatingProcessDetails) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to updatePackages()")
        let showRealTimeTerminalOutputs = UserDefaults.standard.bool(forKey: "showRealTimeTerminalOutputOfOperations")
        let updatedPackages = CurrentValueSubject<Bool, Error>(true)
        return updatedPackages
            .filter { $0 }
            .asyncMap { _ in
                //if let _ = BrewService.shared.brewReadyForAsyncStream() {
                    for await terminalOutput in brew(["upgrade"]) {
                        switch terminalOutput {
                        case let .standardOutput(outputLine):
                            if showRealTimeTerminalOutputs {
                                updateProgressTracker.realTimeOutput.append(RealTimeTerminalLine(line: outputLine))
                            }
                            if outputLine.contains("Downloading") {
                                detailStage.currentStage = .downloading
                            } else if outputLine.contains("Pouring") {
                                detailStage.currentStage = .pouring
                            } else if outputLine.contains("cleanup") {
                                detailStage.currentStage = .cleanup
                            } else if outputLine.contains("Backing App") {
                                detailStage.currentStage = .backingUp
                            } else if outputLine.contains("Moving App") || outputLine.contains("Linking") {
                                detailStage.currentStage = .linking
                            } else {
                                detailStage.currentStage = .cleanup
                            }
                            updateProgressTracker.updateProgress = updateProgressTracker.updateProgress + 0.1
                        case let .standardError(errorLine):
                            if showRealTimeTerminalOutputs {
                                updateProgressTracker.realTimeOutput.append(RealTimeTerminalLine(line: errorLine))
                            }
                            if errorLine.contains("tap") || errorLine.contains("No checksum defined for") {
                                updateProgressTracker.updateProgress = updateProgressTracker.updateProgress + 0.1
                                AppLogger.homeBrew.log("Ignorable upgrade function error: \(errorLine)")
                            } else {
                                AppLogger.homeBrew.log("Upgrade function error: \(errorLine)")
                                updateProgressTracker.errors.append("Upgrade error: \(errorLine)")
                            }
                        }
                    }
                    //BrewService.shared.brewTerminate()
                //}
                updateProgressTracker.updateProgress = 9
                return true
            }
            .eraseToAnyPublisher()
    }
    
    public func updateOutdatedPackagesTracker(brewData: BrewDataStorage, outdatedPackageTracker: OutdatedPackageTracker) -> AnyPublisher<Bool, Error> {
        AppLogger.homeBrew.log("Call to updateOutdatedPackagesTracker()")
        let emptyOutdatedPackagesList = CurrentValueSubject<Bool, Error>(true)
        return emptyOutdatedPackagesList
            .filter { $0 }
            .asyncMap { _ in
                outdatedPackageTracker.outdatedPackages = try await getOutdatedPackages(brewData: brewData)
                return true
            }
            .eraseToAnyPublisher()
    }
    
    public init() {
        
    }
}

public struct MockedHomeBrewShellRepository: HomeBrewShellRepositoryProtocol {
    
    public func outdatedPackages(brewData: BrewDataStorage) -> AnyPublisher<Set<OutdatedPackage>, Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func uninstallPackage(packageName: String, shouldRemoveAllAssociatedFiles: Bool) -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func uninstallTap(tapName: String) -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func pinAndUnpinPackage(packageName: String, pinned: Bool) -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func getTapInfo(tapName: String) -> AnyPublisher<BrewTapInfo, Error> {
        return Just(BrewTapInfo.mockedData[0])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func getPackageInfo(packageName: String, isCask: Bool) -> AnyPublisher<BrewPackageInfo, Error> {
        return Just(BrewPackageInfo.mockedData[0])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func hasLoadedHomeBrewFormulae() -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func hasLoadedHomeBrewCasks() -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func hasLoadedHomeBrewTaps() -> AnyPublisher<Bool, Error> {
        return Just(false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func homeBrewFormulae() -> AnyPublisher<[BrewPackage], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func homeBrewCasks() -> AnyPublisher<[BrewPackage], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func homeBrewTaps() -> AnyPublisher<[BrewTap], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func removingOrphans() -> AnyPublisher<TypeOfResult, Error> {
        return Just(TypeOfResult.intType(0))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func purgeHomebrewCache() -> AnyPublisher<TypeOfResult, Error> {
        return Just(TypeOfResult.stringArrayType([String].init()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func deleteCachedDownloads() -> AnyPublisher<TypeOfResult, Error> {
        return Just(TypeOfResult.intType(0))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func performBrewHealthCheck() -> AnyPublisher<TypeOfResult, Error> {
        return Just(TypeOfResult.boolType(false))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func addTap(tapName: String) -> AnyPublisher<TypeOfResult, Error> {
        return Just(TypeOfResult.boolType(false))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func addPackage(packageName: String) -> AnyPublisher<TypeOfResult, Error> {
        return Just(TypeOfResult.boolType(false))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func brewPackageDescription(packageName: String, isCask: Bool) -> AnyPublisher<BrewPackageDescription, Error> {
        return Just(BrewPackageDescription(name: "PackageName", description: "", isCompatible: false))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func searchPackages(packageName: String, isCask: Bool) -> AnyPublisher<[String], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func updateOnePackage(packageName: String, isCask: Bool) -> AnyPublisher<Bool, Error> {
        let wasUpdateSuccessful = CurrentValueSubject<Bool, Error>(true)
        return wasUpdateSuccessful
            .eraseToAnyPublisher()
    }
    
    public func updatablePackagesAvailable(_ updateProgressTracker: UpdateProgressTracker, outdatedPackageTracker: OutdatedPackageTracker) -> AnyPublisher<Bool, Error> {
        let hasUpdatablePackages = CurrentValueSubject<Bool, Error>(true)
        return hasUpdatablePackages
            .eraseToAnyPublisher()
    }
    
    public func updatePackages(updateProgressTracker: UpdateProgressTracker, detailStage: UpdatingProcessDetails) -> AnyPublisher<Bool, Error> {
        let updatedPackages = CurrentValueSubject<Bool, Error>(true)
        return updatedPackages
            .eraseToAnyPublisher()
    }
    
    public func updateOutdatedPackagesTracker(brewData: BrewDataStorage, outdatedPackageTracker: OutdatedPackageTracker) -> AnyPublisher<Bool, Error> {
        let emptyOutdatedPackagesList = CurrentValueSubject<Bool, Error>(true)
        return emptyOutdatedPackagesList
            .eraseToAnyPublisher()
    }
    
    
    public init() {
        
    }
}
