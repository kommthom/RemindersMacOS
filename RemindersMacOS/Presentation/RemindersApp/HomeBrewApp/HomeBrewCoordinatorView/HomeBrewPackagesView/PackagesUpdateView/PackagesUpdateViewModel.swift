//
//  PackagesUpdateViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 01.11.23.
//

import Foundation
import SwiftUI
import Reminders_Domain

class PackagesUpdateViewModel: ObservableObject {
    // MARK: Use Cases
    
    private let areUpdatablePackagesAvailableUseCase: AreUpdatablePackagesAvailableUCProtocol
    private let updatePackagesUseCase: UpdatePackagesUCProtocol
    private let updateOutdatedPackagesTrackerUseCase: UpdateOutdatedPackagesTrackerUCProtocol
    
    // MARK: - Observable Properties -
    
    @Published var packageUpdatingStep: PackageUpdatingProcessSteps = .checkingForUpdates
    @Published var actionSuccess: Executable<Bool> = .notRequested
    var maintenanceResultStates: MaintenanceResultStates = .init()
    var finalAction: () -> Void
    
    init(areUpdatablePackagesAvailableUseCase: AreUpdatablePackagesAvailableUCProtocol, updatePackagesUseCase: UpdatePackagesUCProtocol, updateOutdatedPackagesTrackerUseCase: UpdateOutdatedPackagesTrackerUCProtocol) {
        self.areUpdatablePackagesAvailableUseCase = areUpdatablePackagesAvailableUseCase
        self.updatePackagesUseCase = updatePackagesUseCase
        self.updateOutdatedPackagesTrackerUseCase = updateOutdatedPackagesTrackerUseCase
        self.finalAction = dummy
    }
    
    func nextStep(nextStep: PackageUpdatingProcessSteps) -> Void {
        actionSuccess = .notRequested
        packageUpdatingStep = nextStep
    }
    
    func executeStep(currentStepText: inout LocalizedStringKey, updateProgressTracker: UpdateProgressTracker, detailStage: UpdatingProcessDetails, outdatedPackageTracker: OutdatedPackageTracker, brewData: BrewDataStorage) -> Void {
        switch packageUpdatingStep {
        case .checkingForUpdates:
            currentStepText = "update-packages.updating.checking"
            areUpdatablePackagesAvailableUseCase
                .execute(updateProgressTracker: updateProgressTracker, outdatedPackageTracker: outdatedPackageTracker, success: executableSubject(\.actionSuccess))
        case .updatingPackages:
            currentStepText = "update-packages.updating.updating"
            updatePackagesUseCase
                .execute(updateProgressTracker: updateProgressTracker, detailStage: detailStage, success: executableSubject(\.actionSuccess))
        case .updatingOutdatedPackageTracker:
            currentStepText = "update-packages.updating.updating-outdated-package"
            updateOutdatedPackagesTrackerUseCase
                .execute(brewData: brewData, outdatedPackageTracker: outdatedPackageTracker, success: executableSubject(\.actionSuccess))
        case .finished:
            currentStepText = "update-packages.updating.finished"
            actionSuccess = .executed(true)
        }
    }

}
