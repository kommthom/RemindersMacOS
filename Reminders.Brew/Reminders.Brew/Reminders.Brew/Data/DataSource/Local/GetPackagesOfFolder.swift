//
//  GetPackagesOfFolder.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.10.23.
//


import Foundation
import SwiftyJSON
import Combine
import Reminders_Domain

//@MainActor
func getPackagesOfFolder(packageType: PackageType) -> AnyPublisher<[BrewPackage], Error> {
    var packagesOfFolder: [BrewPackage] = .init()
    var errorPackages: [String] = .init()
    var versionAsArray: [String]
    var packageURL: URL?
    var firstVersionURL: URL?

    let targetFolder = getTargetFolder(packageType: packageType)
    var temporaryVersionStorage: [String] = .init()
    //FileManagerService.shared.semaphoreWait()
    //let packages: [String] = FileManagerService.shared.getContentsOfFolder(packageType: packageType)
    do {
        let packages: [String] = try FileManager.default.contentsOfDirectory(atPath: targetFolder.path)
        for package in packages {
            if !package.starts(with: ".") { // ignore internal folders like .DS_Store
                //let versions = FileManagerService.shared.contentsOfDirectory(packageType: packageType, appendingPathComponent: package,  includingPropertiesForKeys: [.isHiddenKey], options: .skipsHiddenFiles)
                let versions = try FileManager.default.contentsOfDirectory(at: targetFolder.appendingPathComponent(package, conformingTo: .folder), includingPropertiesForKeys: [.isHiddenKey], options: .skipsHiddenFiles)
                for version in versions { // Check if what we're about to add are actual versions or just some supporting folder
                    if !version.lastPathComponent.starts(with: ".") {  // ignore internal folders like .DS_Store
                        if let _ = packageURL {
                            firstVersionURL = version
                            versionAsArray = version.pathComponents
                            versionAsArray.removeLast()
                            packageURL = URL(string: versionAsArray.joined(separator: "/") )!
                            AppLogger.homeBrew.log("URL of this package: \(packageURL!)")
                        }
                        AppLogger.homeBrew.log("Found desirable version: \(version). Appending to temporary package list")
                        temporaryVersionStorage.append(version.lastPathComponent)
                    }
                }
                //let installedOn: Date? = FileManagerService.shared.attributesOfItem(packageType: packageType, appendingPathComponent: package)[.creationDate] as? Date
                let installedOn: Date? = (try? FileManager.default.attributesOfItem(atPath: targetFolder.appendingPathComponent(package, conformingTo: .folder).path))?[.creationDate] as? Date
                //let folderSizeRaw: Int64? = FileManagerService.shared.directorySize(packageType: packageType, appendingPathComponent: package)
                let folderSizeRaw: Int64? = directorySize(url: targetFolder.appendingPathComponent(package, conformingTo: .directory))
                AppLogger.homeBrew.log("\n Installation date for package \(package) is \(installedOn ?? Date()) \n")
                if packageType == .formula {
                    /// Check if the package has any versions installed
                    if let _ = firstVersionURL {
                        let fileName = "INSTALL_RECEIPT.json"
                        let packageVersion = "\(package)/\(firstVersionURL!.lastPathComponent)"
                        let target = targetFolder.appendingPathComponent(packageVersion, conformingTo: .folder).appendingPathComponent(fileName, conformingTo: .json)
                        let packageInfoJSON: JSON? =  try parseJSON(from: String(contentsOfFile: target.path, encoding: .utf8))
                        var wasPackageInstalledIntentionally: Bool = false
                        if FileManager.default.fileExists(atPath: target.path) {
                            wasPackageInstalledIntentionally = packageInfoJSON!["installed_on_request"].boolValue
                        }
                        AppLogger.homeBrew.log("Package \(package) \(wasPackageInstalledIntentionally ? "was installed intentionally" : "was not installed intentionally")")
                        packagesOfFolder.append(BrewPackage(name: package, isCask: false, installedOn: installedOn, versions: temporaryVersionStorage, installedIntentionally: wasPackageInstalledIntentionally, sizeInBytes: folderSizeRaw))
                    } else {
                        AppLogger.homeBrew.log("\(package) does not have any versions installed")
                        errorPackages.append(package)
                        //appState.corruptedPackage = package
                        //appState.fatalAlertType = .installedPackageHasNoVersions
                        //appState.isShowingFatalError = true
                    }
                } else {
                    packagesOfFolder.append(BrewPackage(name: package, isCask: true, installedOn: installedOn, versions: temporaryVersionStorage, sizeInBytes: folderSizeRaw))
                }
            }
        }
    } catch let error {
        AppLogger.homeBrew.log(level: .error, "getPackagesOfFolder error: \(error.localizedDescription)")
    }
    if errorPackages.isEmpty {
        //FileManagerService.shared.semaphoreSignal()
        return Just(packagesOfFolder)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    } else {
        //FileManagerService.shared.semaphoreSignal()
        return Fail(error: GetPackagesOfFolderError.emptyFolders(folderNames: errorPackages))
            .eraseToAnyPublisher()
    }
}

@MainActor
func hasHomeBrewPackages(packageType: PackageType) -> AnyPublisher<Bool, Error> {
    do {
        //FileManagerService.shared.semaphoreWait()
        let targetFolder = getTargetFolder(packageType: packageType)
        AppLogger.homeBrew.log("Call to hasHomeBrewPackages(targetFolder: \(packageType.url)")
        //let packages = FileManagerService.shared.contentsOfDirectory(packageType: packageType)
        let packages = try FileManager.default.contentsOfDirectory(atPath: targetFolder.path)
        //FileManagerService.shared.semaphoreSignal()
        return Just((packages.count > 0))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    } catch let error {
        AppLogger.homeBrew.log(level: .error, "getPackagesOfFolder error: \(error.localizedDescription)")
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}

func getTargetFolder(packageType: PackageType) -> URL {
    switch packageType {
    case .cask:
        HomeBrewConstants.brewCaskPath
    case.formula:
        HomeBrewConstants.brewCellarPath
    case .tap:
        HomeBrewConstants.tapPath
    }
}
