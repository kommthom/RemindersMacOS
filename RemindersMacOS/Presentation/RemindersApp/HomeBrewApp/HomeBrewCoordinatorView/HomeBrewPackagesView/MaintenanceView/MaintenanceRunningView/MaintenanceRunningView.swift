//
//  MaintenanceRunningView.swift
//  RemindersMacOS
//
//  Created by Thomas on 25.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct MaintenanceRunningView: View {
    let store: StoreOf<MaintenanceRunning>
    
    @StateObject var viewModel: MaintenanceViewModel = DIContainer.shared.resolve()
    @State var currentMaintenanceStepText: LocalizedStringKey = "maintenance.step.initial"
    
    init(store: StoreOf<MaintenanceRunning>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            let _ = viewModel.setUpViewModel(shouldUninstallOrphans: viewStore.state.shouldUninstallOrphans, shouldPurgeCache: viewStore.state.shouldPurgeCache, shouldDeleteDownloads: viewStore.state.shouldDeleteDownloads, shouldPerformHealthCheck: viewStore.state.shouldPerformHealthCheck, finalAction: { viewStore.send(.maintenanceFinishedButtonTapped(viewModel.maintenanceResultStates)) } )
            switch viewModel.actionSuccess {
            case .notRequested:
                Text(currentMaintenanceStepText)
                    .onAppear(perform: {
                        while !viewModel.executeMaintenanceStep(currentMaintenanceStepText: &currentMaintenanceStepText) {
                        }
                    })
            case .isExecuting(_, _):
                ProgressView {
                    Text(currentMaintenanceStepText)
                }
                .padding()
                .frame(width: 200)
            case .executed(let success):
                let _ = viewModel.nextMaintenanceStep(success: success)
                Text("action.success")
            case .failed(let error):
                ErrorView(error: error, retryAction: viewModel.retryMaintenanceStep)
            }
        }
    }
}

/*#Preview {
    MaintenanceRunningView()
}*/
