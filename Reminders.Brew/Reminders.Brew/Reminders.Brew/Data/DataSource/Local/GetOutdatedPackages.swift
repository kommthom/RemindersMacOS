//
//  GetOutdatedPackages.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import Foundation
import Reminders_Domain

//@MainActor
func getOutdatedPackages(brewData: BrewDataStorage) async throws -> Set<OutdatedPackage> {
    var outdatedPackages: Set<OutdatedPackage> = .init()
    let _ = await brew(["update"])
    let outdatedPackagesCommandOutput: TerminalOutput = await brew(["outdated"])
    AppLogger.homeBrew.log("Outdated packages output: \(outdatedPackagesCommandOutput)")
    if outdatedPackagesCommandOutput.standardError.contains("HOME must be set") {
        AppLogger.homeBrew.log("Encountered HOME error")
        throw GetOutdatedPackagesError.homeNotSet
    }
    AppLogger.homeBrew.log("All outdated packages output: \(outdatedPackagesCommandOutput.standardOutput)")
    for outdatedPackage in outdatedPackagesCommandOutput.standardOutput.components(separatedBy: "\n") {
        if let foundOutdatedFormula = await brewData.installedFormulae.filter({ $0.name == outdatedPackage && $0.installedIntentionally }).first {
            // Only show the intentionally-installed packages. The users don't care about dependencies
            outdatedPackages.insert(OutdatedPackage(package: foundOutdatedFormula))
        } else if let foundOutdatedCask = await brewData.installedCasks.filter({ $0.name == outdatedPackage && $0.installedIntentionally}).first {
            outdatedPackages.insert(OutdatedPackage(package: foundOutdatedCask))
        }
    }
    AppLogger.homeBrew.log("Call to getOutdatedPackages() finished")
    return outdatedPackages
}
