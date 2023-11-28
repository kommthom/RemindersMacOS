//
//  PackageDetailViewModelState.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.11.23.
//

import Foundation
import Reminders_Domain

class PackageDetailViewModelState {
    
    var brewPackageInfo: BrewPackageInfo? = nil
    
    // MARK: Observable Properties
    
    @Published var homeBrewPackageInfo: Loadable<BrewPackageInfo> = .notRequested {
        didSet {
            switch homeBrewPackageInfo {
            case .loaded(let result):
                brewPackageInfo = result
                pinned = brewPackageInfo?.pinned
                homePage = brewPackageInfo?.homePage
                installedAsDependency = brewPackageInfo?.installedAsDependency
                packageDependents = brewPackageInfo?.packageDependents
                outdated = brewPackageInfo?.outdated
                caveats = brewPackageInfo?.caveats
                description = brewPackageInfo?.description
                tap = brewPackageInfo?.tap
                dependencies = brewPackageInfo?.dependencies
                AppLogger.homeBrew.log("BrewPackage Loaded")
            case .notRequested:
                AppLogger.homeBrew.log("BrewPackage Not Loaded")
            case .isLoading(_, _):
                AppLogger.homeBrew.log("BrewPackage Loading")
            case .failed(let error):
                AppLogger.homeBrew.log(level: .error, "BrewPackage Loading Error: \(error.localizedDescription)")
            }
        }
    }
    @Published var pinAndUnpinSuccess: Executable<Bool> = .notRequested {
        didSet {
            switch pinAndUnpinSuccess {
            case .executed(let result):
                if result {
                    brewPackageInfo?.pinned.toggle()
                    pinned?.toggle()
                }
                Delay(1).performWork {
                    self.pinAndUnpinSuccess = .notRequested
                }
            case .failed(_):
                Delay(1).performWork {
                    self.pinAndUnpinSuccess = .notRequested
                }
            default:
                dummy()
            }
            
        }
    }
    @Published var pinned: Bool?
    @Published var homePage: URL?
    @Published var installedAsDependency: Bool?
    @Published var packageDependents: [String]?
    @Published var outdated: Bool?
    @Published var caveats: String?
    @Published var description: String?
    @Published var tap: String?
    @Published var dependencies: [BrewPackageDependency]?
}
