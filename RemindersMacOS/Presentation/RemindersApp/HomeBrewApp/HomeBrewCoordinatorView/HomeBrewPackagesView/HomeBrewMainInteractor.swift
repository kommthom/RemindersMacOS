//
//  HomeBrewMainInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Reminders_Domain

final class HomeBrewMainInteractor: HomeBrewMainInteractorProtocol {
    
    // MARK: Use Cases
    
    private var getHomeBrewTapsUseCase: GetHomeBrewTapsUCProtocol
    private var unInstallTapUseCase: UninstallTapUCProtocol
    private var getHomeBrewCasksUseCase: GetHomeBrewCasksUCProtocol
    private var getHomeBrewFormulaeUseCase: GetHomeBrewFormulaeUCProtocol
    private var unInstallPackageUseCase: UninstallPackageUCProtocol
    private var getOutdatedPackagesUseCase: GetOutdatedPackagesUCProtocol
    
    init(getHomeBrewFormulaeUseCase: GetHomeBrewFormulaeUCProtocol, getHomeBrewCasksUseCase: GetHomeBrewCasksUCProtocol, unInstallPackageUseCase: UninstallPackageUCProtocol, getHomeBrewTapsUseCase: GetHomeBrewTapsUCProtocol, unInstallTapUseCase: UninstallTapUCProtocol, getOutdatedPackagesUseCase: GetOutdatedPackagesUCProtocol) {
        self.getHomeBrewFormulaeUseCase = getHomeBrewFormulaeUseCase
        self.getHomeBrewCasksUseCase = getHomeBrewCasksUseCase
        self.unInstallPackageUseCase = unInstallPackageUseCase
        self.getHomeBrewTapsUseCase = getHomeBrewTapsUseCase
        self.unInstallTapUseCase = unInstallTapUseCase
        self.getOutdatedPackagesUseCase = getOutdatedPackagesUseCase
    }
    
    @MainActor
    func removePackage(actionName: String?, tracker: PackageType, brewData: BrewDataStorage) {
        if let _ = actionName {
            switch tracker {
            case .formula:
                brewData.removeFormulaFromTracker(withName: actionName!)
            case .cask:
                brewData.removeCaskFromTracker(withName: actionName!)
            case .tap:
                brewData.removeTapFromTracker(withName: actionName!)
            }
        }
    }
    
    @MainActor
    func changeTaggedStatus(packageName: String, brewData: BrewDataStorage, tracker: PackageType) {
        brewData.changeTaggedStatus(withName: packageName, tracker: tracker)
    }
    
    @MainActor
    func setHasErrorStatus(packageName: String, brewData: BrewDataStorage, tracker: PackageType) {
        brewData.setHasErrorStatus(withName: packageName, tracker: tracker)
    }
    
    @MainActor
    func uninstall(packageName: String, brewData: BrewDataStorage, tracker: PackageType, shouldRemoveAllAssociatedFiles: Bool, success: ExecutableSubject<Bool>) {
        brewData.toggleIsBeingModified(withName: packageName, tracker: tracker)
        switch tracker {
        case .tap:
            unInstallTapUseCase.execute(tapName: packageName, success: success)
        case .formula, .cask:
            unInstallPackageUseCase.execute(packageName: packageName, shouldRemoveAllAssociatedFiles: false, success: success)
        }
    }
    
    func loadTaps(homeBrewTaps: LoadableSubject<[BrewTap]>) {
        getHomeBrewTapsUseCase
            .execute(homeBrewTaps: homeBrewTaps)
    }

    func loadFormulae(homeBrewFormulae: LoadableSubject<[BrewPackage]>) {
        getHomeBrewFormulaeUseCase
            .execute(homeBrewFormule: homeBrewFormulae)
    }

    func loadCasks(homeBrewCasks: LoadableSubject<[BrewPackage]>) {
        getHomeBrewCasksUseCase
            .execute(homeBrewCasks: homeBrewCasks)
    }
    
    func loadOutdatedPackages(brewData: BrewDataStorage, outdatedPackages: LoadableSubject<Set<OutdatedPackage>>) {
        getOutdatedPackagesUseCase
            .execute(brewData: brewData, outdatedPackages: outdatedPackages)
    }
}
