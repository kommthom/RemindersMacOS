//
//  SearchForPackageByID.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import Foundation
import Reminders_Domain

public func getTopPackageFromUUID(requestedPackageUUID: UUID, isCask: Bool, topPackageTracker: TopPackagesTracker) throws -> BrewPackage {
    if isCask {
        guard let foundTopCask: TopPackage = topPackageTracker.topCasks.filter({ $0.id == requestedPackageUUID }).first else {
            throw TopPackageRetrievalError.resultingArrayWasEmptyEvenThoughPackagesWereInIt
        }
        return BrewPackage(name: foundTopCask.packageName, isCask: isCask, installedOn: nil, versions: [], sizeInBytes: nil)
    } else {
        guard let foundTopFormula: TopPackage = topPackageTracker.topFormulae.filter({ $0.id == requestedPackageUUID }).first else {
            throw TopPackageRetrievalError.resultingArrayWasEmptyEvenThoughPackagesWereInIt
        }
        return BrewPackage(name: foundTopFormula.packageName, isCask: isCask, installedOn: nil, versions: [], sizeInBytes: nil)
    }
}

public func getPackageFromUUID(requestedPackageUUID: UUID, tracker: SearchResultTracker) throws -> BrewPackage {
    var filteredPackage: BrewPackage?

    if tracker.foundFormulae.count != 0 {
        filteredPackage = tracker.foundFormulae.filter({ $0.id == requestedPackageUUID }).first
    }
    if filteredPackage == nil {
        filteredPackage = tracker.foundCasks.filter({ $0.id == requestedPackageUUID }).first
    }
    if let _ = filteredPackage {
        return filteredPackage!
    } else {
        throw PackageRetrievalByUUIDError.couldNotfindAnypackagesInTracker
    }
}

