//
//  IncrementalPackagesUpdateViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.11.23.
//

import Foundation
import SwiftUI
import Reminders_Domain

class IncrementalPackagesUpdateViewModel: ObservableObject {
    // MARK: Use Cases
    
    private let updateOnePackageUseCase: UpdateOnePackageUCProtocol
    
    // MARK: - Observable Properties -
    
    @Published var actionSuccess: Executable<Bool> = .notRequested
    @Published var packageUpdatingErrors: [String] = .init()
    
    init(updateOnePackageUseCase: UpdateOnePackageUCProtocol) {
        self.updateOnePackageUseCase = updateOnePackageUseCase
    }
    
    func nextStep(index: inout Int, max: Int, updateProgress: inout Double) -> Bool {
        index += 1
        updateProgress = updateProgress + (Double(max) / 100)
        if index < max {
            actionSuccess = .notRequested
            return true
        } else { // no next step
            return false
        }
    }
    
    func nextStepWithError(index: inout Int, max: Int, updateProgress: inout Double, error: Error) -> Bool {
        switch error {
        case UpdatingPackageError.outputHadErrors(errorLine: let errorLine):
            packageUpdatingErrors.append(errorLine)
        default:
            packageUpdatingErrors.append(error.localizedDescription)
        }
        return nextStep(index: &index, max: max, updateProgress: &updateProgress)
    }
    
    func execute(packageName: String, isCask: Bool) -> Void {
        updateOnePackageUseCase
            .execute(packageName: packageName, isCask: isCask, success: executableSubject(\.actionSuccess))
    }
    
    func removeUpdatedPackages(outdatedPackageTracker: OutdatedPackageTracker, namesOfUpdatedPackages: [String]) -> Set<OutdatedPackage> {
        outdatedPackageTracker.outdatedPackages = outdatedPackageTracker.outdatedPackages.filter { outdatedPackage in
            return !namesOfUpdatedPackages.contains(outdatedPackage.package.name)
        }
        return outdatedPackageTracker.outdatedPackages
    }
}
