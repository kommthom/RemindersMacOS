//
//  PackagesUpdateView.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct PackagesUpdateView: View {
    let store: StoreOf<PackagesUpdate>
    
    @EnvironmentObject var updateProgressTracker: UpdateProgressTracker
    @EnvironmentObject var brewData: BrewDataStorage
    @EnvironmentObject var outdatedPackageTracker: OutdatedPackageTracker
    @State private var isRealTimeTerminalOutputExpanded: Bool = false
    @State var currentStepText: LocalizedStringKey = "update-packages.updating.ready"
    @StateObject var updateProcessDetailsStage: UpdatingProcessDetails = .init()
    @StateObject var viewModel: PackagesUpdateViewModel = DIContainer.shared.resolve()
    
    init(store: StoreOf<PackagesUpdate>) {
        self.store = store
        updateProgressTracker.updateProgress = 0
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                switch viewModel.actionSuccess {
                case .notRequested:
                    Text("").onAppear(perform: {
                        viewModel.executeStep(currentStepText: &currentStepText, updateProgressTracker: updateProgressTracker, detailStage: updateProcessDetailsStage, outdatedPackageTracker: outdatedPackageTracker, brewData: brewData)
                    })
                case .isExecuting(let last, _):
                    updatingPackagesView(last: last)
                case .executed(let updateAvailability):
                    switch viewModel.packageUpdatingStep {
                    case .checkingForUpdates:
                        if updateAvailability { //restart with next step
                            let _ = viewModel.nextStep(nextStep: .updatingPackages)
                        } else {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.seal")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.secondary)
                                VStack(alignment: .leading) {
                                    Text("update-packages.no-updates")
                                        .font(.headline)
                                    Text("update-packages.no-updates.description")
                                }
                                .fixedSize()
                            }
                            .onAppear(perform: {
                                Delay(3).performWork {
                                    viewStore.send(.goBackTapped)
                                }
                            })
                        }
                    case .updatingPackages:
                        let _ = viewModel.nextStep(nextStep: .updatingOutdatedPackageTracker)
                    case .updatingOutdatedPackageTracker:
                        let _ = viewModel.nextStep(nextStep: .finished)
                    case .finished:
                        //return Text("update-packages.updating.finished")
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.seal")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.secondary)
                            VStack(alignment: .leading) {
                                Text("update-packages.finished")
                                    .font(.headline)
                                Text("update-packages.finished.description")
                            }
                            .fixedSize()
                        }
                        .onAppear(perform: {
                            Delay(10).performWork {
                                viewStore.send(.goBackTapped)
                            }
                        })
                    }
                case .failed(let error):
                    ErrorView(error: error, retryAction: { viewModel.executeStep(currentStepText: &currentStepText, updateProgressTracker: updateProgressTracker, detailStage: updateProcessDetailsStage, outdatedPackageTracker: outdatedPackageTracker, brewData: brewData) })
                }
            }
        }
    }
    
    func updatingPackagesView(last: Bool?) -> some View {
        ProgressView(value: updateProgressTracker.updateProgress, total: 10) {
            switch viewModel.packageUpdatingStep {
            case .checkingForUpdates:
                VStack(alignment: .leading) {
                    Text(currentStepText)
                    LiveTerminalOutputView(
                        lineArray: $updateProgressTracker.realTimeOutput,
                        isRealTimeTerminalOutputExpanded: $isRealTimeTerminalOutputExpanded,
                        forceKeepTerminalOutputInMemory: true
                    )
                }
            case .updatingPackages:
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(currentStepText)
                        Text(updateProcessDetailsStage.currentStage.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    LiveTerminalOutputView(
                        lineArray: $updateProgressTracker.realTimeOutput,
                        isRealTimeTerminalOutputExpanded: $isRealTimeTerminalOutputExpanded
                    )
                }
            case .updatingOutdatedPackageTracker:
                Text(currentStepText)
            case .finished:
                Text(currentStepText)
            }
        }
        .padding()
        .fixedSize()
        //deprecated .animation(.none)
    }

}

/*#Preview {
    PackagesUpdateView()
}*/
