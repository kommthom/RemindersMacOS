//
//  MaintenanceViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.10.23.
//

import SwiftUI
import Reminders_Domain

func dummy() -> Void {
}

class MaintenanceViewModel: ObservableObject {
    // MARK: Use Cases
    
    private let removeOrphansUseCase: RemoveOrphansUCProtocol
    private let purgeHomebrewCacheUseCase: PurgeHomebrewCacheUCProtocol
    private let deleteCachedDownloadsUseCase: DeleteCachedDownloadsUCProtocol
    private let performBrewHealthCheckUseCase: PerformBrewHealthCheckUCProtocol
    
    // MARK: - Observable Properties -
    
    @Published var maintenanceStep: MaintenanceStep = .removingOrphans
    @Published var actionSuccess: Executable<TypeOfResult> = .notRequested
    var maintenanceResultStates: MaintenanceResultStates = .init()
    var finalAction: () -> Void
    
    init(removeOrphansUseCase: RemoveOrphansUCProtocol, purgeHomebrewCacheUseCase: PurgeHomebrewCacheUCProtocol, deleteCachedDownloadsUseCase: DeleteCachedDownloadsUCProtocol, performBrewHealthCheckUseCase: PerformBrewHealthCheckUCProtocol) {
        self.removeOrphansUseCase = removeOrphansUseCase
        self.purgeHomebrewCacheUseCase = purgeHomebrewCacheUseCase
        self.deleteCachedDownloadsUseCase = deleteCachedDownloadsUseCase
        self.performBrewHealthCheckUseCase = performBrewHealthCheckUseCase
        self.finalAction = dummy
    }
    
    func retryMaintenanceStep() -> Void {
        var temp: LocalizedStringKey = ""
        let _ = executeMaintenanceStep(currentMaintenanceStepText: &temp)
    }
    
    func executeMaintenanceStep(currentMaintenanceStepText: inout LocalizedStringKey) -> Bool {
        switch maintenanceStep {
        case .removingOrphans:
            if maintenanceResultStates.shouldUninstallOrphans {
                removeOrphansUseCase
                    .execute(numberOfOrphansRemoved: executableSubject(\.actionSuccess))
                currentMaintenanceStepText = "maintenance.step.removing-orphans"
                return true
            } else {
                maintenanceStep = .purgingCache
                return false
            }
        case .purgingCache:
            if maintenanceResultStates.shouldPurgeCache {
                purgeHomebrewCacheUseCase
                    .execute(packagesHoldingBackCachePurge: executableSubject(\.actionSuccess))
                currentMaintenanceStepText = "maintenance.step.purging-cache"
                return true
            } else {
                maintenanceStep = .deletingDownloads
                return false
            }
        case .deletingDownloads:
            if maintenanceResultStates.shouldDeleteDownloads {
                deleteCachedDownloadsUseCase
                    .execute(reclaimedSpaceAfterCachePurge: executableSubject(\.actionSuccess))
                currentMaintenanceStepText = "maintenance.step.deleting-cached-downloads"
                return true
            } else {
                maintenanceStep = .healthCheck
                return false
            }
        case .healthCheck:
            if maintenanceResultStates.shouldPerformHealthCheck {
                performBrewHealthCheckUseCase
                    .execute(brewHealthCheckFoundNoProblems: executableSubject(\.actionSuccess))
                currentMaintenanceStepText = "maintenance.step.running-health-check"
                return true
            } else {
                maintenanceStep = .finished
                return false
            }
        case .finished:
            finalAction()
            return true
        }
    }
    
    func nextMaintenanceStep(success: TypeOfResult) -> Bool {
        switch maintenanceStep {
        case .removingOrphans:
            switch success {
            case .intType(let intValue):
                maintenanceResultStates.numberOfOrphansRemoved = intValue
            case .boolType(_), .stringArrayType(_), .stringType(_):
                maintenanceResultStates.numberOfOrphansRemoved = 0
            }
            actionSuccess = .notRequested
            maintenanceStep = .purgingCache
        case .purgingCache:
            switch success {
            case .stringArrayType(let stringArrayValue):
                maintenanceResultStates.packagesHoldingBackCachePurge = stringArrayValue
            case .boolType(_), .intType(_), .stringType(_):
                maintenanceResultStates.packagesHoldingBackCachePurge = []
            }
            actionSuccess = .notRequested
            maintenanceStep = .deletingDownloads
        case .deletingDownloads:
            switch success {
            case .intType(let intValue):
                maintenanceResultStates.reclaimedSpaceAfterCachePurge = intValue
            case .boolType(_), .stringArrayType(_), .stringType(_):
                maintenanceResultStates.reclaimedSpaceAfterCachePurge = 0
            }
            actionSuccess = .notRequested
            maintenanceStep = .healthCheck
        case .healthCheck:
            switch success {
            case .boolType(let boolValue):
                maintenanceResultStates.brewHealthCheckFoundNoProblems = boolValue
            case .intType(_), .stringArrayType(_), .stringType(_):
                maintenanceResultStates.brewHealthCheckFoundNoProblems = false
            }
            actionSuccess = .notRequested
            maintenanceStep = .finished
        case .finished: //impossible
            finalAction()
        }
        return true
    }
        
    func setUpViewModel(shouldUninstallOrphans: Bool, shouldPurgeCache: Bool, shouldDeleteDownloads: Bool, shouldPerformHealthCheck: Bool, finalAction: @escaping () -> Void) {
        self.maintenanceResultStates.shouldUninstallOrphans = shouldUninstallOrphans
        self.maintenanceResultStates.shouldPurgeCache = shouldPurgeCache
        self.maintenanceResultStates.shouldDeleteDownloads = shouldDeleteDownloads
        self.maintenanceResultStates.shouldPerformHealthCheck = shouldPerformHealthCheck
        self.finalAction = finalAction
    }
}
