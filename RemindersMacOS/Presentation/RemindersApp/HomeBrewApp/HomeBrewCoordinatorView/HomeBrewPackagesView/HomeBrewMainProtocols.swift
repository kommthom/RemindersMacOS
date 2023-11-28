//
//  HomeBrewMainProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Reminders_Domain

protocol HomeBrewMainInteractorProtocol {
    func removePackage(actionName: String?, tracker: PackageType, brewData: BrewDataStorage)
    func changeTaggedStatus(packageName: String, brewData: BrewDataStorage, tracker: PackageType)
    func setHasErrorStatus(packageName: String, brewData: BrewDataStorage, tracker: PackageType)
    func uninstall(packageName: String, brewData: BrewDataStorage, tracker: PackageType, shouldRemoveAllAssociatedFiles: Bool, success: ExecutableSubject<Bool>)
    func loadTaps(homeBrewTaps: LoadableSubject<[BrewTap]>)
    func loadFormulae(homeBrewFormulae: LoadableSubject<[BrewPackage]>)
    func loadCasks(homeBrewCasks: LoadableSubject<[BrewPackage]>)
    func loadOutdatedPackages(brewData: BrewDataStorage, outdatedPackages: LoadableSubject<Set<OutdatedPackage>>)
}

protocol HomeBrewMainViewModelProtocol {
    var state: HomeBrewMainViewModelState { get set }
    var brewData: BrewDataStorage { get set }
    func showFormulae() -> Bool
    func showCasks() -> Bool
    func showTaps() -> Bool
    func isTapIncluded(_ tap: BrewTap) -> Bool
    func isFormulaIncluded(_ formula: BrewPackage) -> Bool
    func isCaskIncluded(_ cask: BrewPackage) -> Bool
    func changeTaggedStatus(packageName: String, tracker: PackageType)
    func uninstall(packageName: String, tracker: PackageType, shouldRemoveAllAssociatedFiles: Bool)
    func loadTaps() -> Void
    func loadFormulae() -> Void
    func loadCasks() -> Void
    func loadOutdatedPackages() -> Void
    var actionType: ActionType { get set }
    func isHandledByMainVM() -> Bool
    func homeBrewInitCheck() -> Void
}
