//
//  HomeBrewMainViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Reminders_Domain
import Reminders_Brew

class HomeBrewMainViewModel: ObservableObject, HomeBrewMainViewModelProtocol {
    @Published var state: HomeBrewMainViewModelState
    @Published var brewData: BrewDataStorage
    private let interactor: HomeBrewMainInteractorProtocol
    
    @MainActor
    @Published var homeBrewFormulae: Loadable<[BrewPackage]> = .notRequested {
        didSet {
            switch homeBrewFormulae {
            case .loaded(let formulae):
                brewData.installedFormulae = Set(formulae)
                hasLoadedFormulae = true
                AppLogger.homeBrew.log("hasLoadedFormulae = true")
            default:
                hasLoadedFormulae = false
            }
        }
    }
    @Published var hasLoadedFormulae: Bool = false
    
    @MainActor
    @Published public var homeBrewCasks: Loadable<[BrewPackage]> = .notRequested {
        didSet {
           switch homeBrewCasks {
           case .loaded(let casks):
               brewData.installedCasks = Set(casks)
               hasLoadedCasks = true
               AppLogger.homeBrew.log("hasLoadedCasks = true")
           default:
               hasLoadedCasks = false
           }
        }
    }
    @Published var hasLoadedCasks: Bool = false
    
    @MainActor
    @Published public var homeBrewTaps: Loadable<[BrewTap]> = .notRequested {
        didSet {
           switch homeBrewTaps {
           case .loaded(let taps):
               brewData.addedTaps = Set(taps)
               hasLoadedTaps = true
               AppLogger.homeBrew.log("hasLoadedTaps = true")
           default:
               hasLoadedTaps = false
           }
        }
    }
    @Published var hasLoadedTaps: Bool = false
    
    @MainActor
    @Published public var outdatedPackages: Loadable<Set<OutdatedPackage>> = .notRequested {
        didSet {
           switch outdatedPackages {
           case .loaded(let outdatedPackages):
               brewData.outdatedPackages = outdatedPackages
               hasLoadedOutdatedPackages = true
               AppLogger.homeBrew.log("hasLoadedOutdatedPackages = true")
           default:
               hasLoadedOutdatedPackages = false
           }
        }
    }
    @Published var hasLoadedOutdatedPackages: Bool = false
    
    var actionType: ActionType = .none
    @Published var actionSuccess: Executable<Bool> = .notRequested {
        didSet {
            switch actionSuccess {
            case .executed(_):
                cleanUp()
            case .failed(_):
                setHasErrorStatus()
            default:
                dummy()
            }
        }
    }
    @Published var cachedDownloadsFolderSize: Int64 = directorySize(url: HomeBrewConstants.brewCachedDownloadsPath)
    
    @MainActor
    init(interactor: HomeBrewMainInteractorProtocol) {
        self.interactor = interactor
        self.brewData = .init()
        self.state = .init()
    }
    
    func showFormulae() -> Bool {
        state.currentTokens.isEmpty || state.currentTokens.contains(where: { $0.tokenSearchResultType == .formula }) || state.currentTokens.contains(where: { $0.tokenSearchResultType == .intentionallyInstalledPackage })
    }
    
    func showCasks() -> Bool {
        state.currentTokens.isEmpty || state.currentTokens.contains(where: { $0.tokenSearchResultType == .cask }) || state.currentTokens.contains(where: { $0.tokenSearchResultType == .intentionallyInstalledPackage })
    }
    
    func showTaps() -> Bool {
        state.currentTokens.isEmpty || state.currentTokens.contains(where: { $0.tokenSearchResultType == .formula }) || state.currentTokens.contains(where: { $0.tokenSearchResultType == .intentionallyInstalledPackage })
    }
    
    @MainActor 
    func isTapIncluded(_ tap: BrewTap) -> Bool {
        state.searchText.isEmpty || state.searchText.contains("#") || tap.name.contains(state.searchText)
    }
    /*func filteredTaps() -> [BrewTap] {
        Array(state.searchText.isEmpty || state.searchText.contains("#") ? brewData.addedTaps : brewData.addedTaps.filter { $0.name.contains(state.searchText) })
    }*/
    
    @MainActor
    func isFormulaIncluded(_ formula: BrewPackage) -> Bool {
        (state.currentTokens.contains(where: { $0.tokenSearchResultType == .intentionallyInstalledPackage }) && (state.searchText.isEmpty || formula.name.contains(state.searchText)) && formula.installedIntentionally) || ((state.searchText.isEmpty || state.searchText.contains("#") || formula.name.contains(state.searchText)) && !formula.name.isEmpty)
    }
    /*func filteredFormulae() -> [BrewPackage] {
        Array(state.currentTokens.contains(where: { $0.tokenSearchResultType == .intentionallyInstalledPackage }) ? (state.searchText.isEmpty ? brewData.installedFormulae.filter({ $0.installedIntentionally == true }) : brewData.installedFormulae.filter({ $0.installedIntentionally == true && $0.name.contains(state.searchText)})) : (state.searchText.isEmpty || state.searchText.contains("#") ? brewData.installedFormulae.filter({ !$0.name.isEmpty }) : brewData.installedFormulae.filter({ $0.name.contains(state.searchText) })))
    }*/
    
    @MainActor
    func isCaskIncluded(_ cask: BrewPackage) -> Bool {
        state.searchText.isEmpty || state.searchText.contains("#") || cask.name.contains(state.searchText)
    }
    /*func filteredCasks() -> [BrewPackage] {
        Array(state.searchText.isEmpty || state.searchText.contains("#") ? brewData.installedCasks : brewData.installedCasks.filter { $0.name.contains(state.searchText) })
    }*/
    
    private func cleanUp() {
        switch actionType {
        case .none, .pinUnpin(_):
            dummy()
        case .uninstallFormulae(let actionName):
            interactor.removePackage(actionName: actionName, tracker: .formula, brewData: brewData)
        case .uninstallCask(let actionName):
            interactor.removePackage(actionName: actionName, tracker: .cask, brewData: brewData)
        case .uninstallTap(let actionName):
            interactor.removePackage(actionName: actionName, tracker: .tap, brewData: brewData)
        }
        Delay(1).performWork {
            self.actionSuccess = .notRequested
        }
    }
    
    private func setHasErrorStatus() {
        switch actionType {
        case .none, .pinUnpin(_):
            dummy()
        case .uninstallFormulae(let actionName):
            interactor.setHasErrorStatus(packageName: actionName, brewData: brewData, tracker: .formula)
        case .uninstallCask(let actionName):
            interactor.setHasErrorStatus(packageName: actionName, brewData: brewData, tracker: .cask)
        case .uninstallTap(let actionName):
            interactor.setHasErrorStatus(packageName: actionName, brewData: brewData, tracker: .tap)
        }
        Delay(1).performWork {
            self.actionSuccess = .notRequested
        }
    }
    
    func changeTaggedStatus(packageName: String, tracker: PackageType) {
        interactor.changeTaggedStatus(packageName: packageName, brewData: brewData, tracker: tracker)
    }
    
    func uninstall(packageName: String, tracker: PackageType, shouldRemoveAllAssociatedFiles: Bool = false) {
        switch tracker {
        case .formula:
            actionType = .uninstallFormulae(packageName)
        case .cask:
            actionType = .uninstallCask(packageName)
        case .tap:
            actionType = .uninstallTap(packageName)
        }
        interactor.uninstall(packageName: packageName, brewData: brewData, tracker: tracker, shouldRemoveAllAssociatedFiles: shouldRemoveAllAssociatedFiles, success: executableSubject(\.actionSuccess))
    }
    
    func loadTaps() {
        interactor.loadTaps(homeBrewTaps: loadableSubject(\.homeBrewTaps))
    }
    
    func loadFormulae() {
        interactor.loadFormulae(homeBrewFormulae: loadableSubject(\.homeBrewFormulae))
    }
    
    func loadCasks() {
        interactor.loadCasks(homeBrewCasks: loadableSubject(\.homeBrewCasks))
    }
    
    func loadOutdatedPackages() {
        interactor
            .loadOutdatedPackages(brewData: brewData, outdatedPackages: loadableSubject(\.outdatedPackages))
    }
    
    func isHandledByMainVM() -> Bool {
        switch actionType {
        case .none, .pinUnpin(_):
            false
        default:
            true
        }
    }
    
    func homeBrewInitCheck() {
        AppLogger.homeBrew.log("Brew executable path: \(HomeBrewConstants.brewExecutablePath)")
        AppLogger.homeBrew.log("Documents directory: \(HomeBrewConstants.documentsDirectoryPath.path)")
        AppLogger.homeBrew.log("System version: \(HomeBrewConstants.osVersionString)")
        if !FileManager.default.fileExists(atPath: HomeBrewConstants.documentsDirectoryPath.path) {
            AppLogger.homeBrew.log("Documents directory does not exist, creating it...")
            try! FileManager.default.createDirectory(at: HomeBrewConstants.documentsDirectoryPath, withIntermediateDirectories: true)
        } else {
            AppLogger.homeBrew.log("Documents directory exists")
        }
        if !FileManager.default.fileExists(atPath: HomeBrewConstants.metadataFilePath.path) {
            AppLogger.homeBrew.log("Metadata file does not exist, creating it...")
            try! Data().write(to: HomeBrewConstants.metadataFilePath, options: .atomic)
        } else {
            AppLogger.homeBrew.log("Metadata file exists")
        }
    }
}
