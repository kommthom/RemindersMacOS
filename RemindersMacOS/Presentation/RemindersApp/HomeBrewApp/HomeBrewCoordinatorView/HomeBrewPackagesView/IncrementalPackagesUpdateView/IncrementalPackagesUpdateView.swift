//
//  IncrementalPackagesUpdateView.swift
//  RemindersMacOS
//
//  Created by Thomas on 24.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct IncrementalPackagesUpdateView: View {
    let store: StoreOf<IncrementalPackagesUpdate>
    @EnvironmentObject var outdatedPackageTracker: OutdatedPackageTracker
    @State private var updateProgress: Double = 0.0
    @StateObject var viewModel: IncrementalPackagesUpdateViewModel = DIContainer.shared.resolve()
    @State private var index: Int = 0
    
    var selectedPackages: [OutdatedPackage] {
        return outdatedPackageTracker.outdatedPackages.filter { $0.isMarkedForUpdating }
    }
    
    init(store: StoreOf<IncrementalPackagesUpdate>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                let outdatedPackage = selectedPackages[index]
                switch viewModel.actionSuccess {
                    case .notRequested:
                        Text("")
                            .onAppear(perform: {
                                viewModel.execute(packageName: outdatedPackage.package.name, isCask: outdatedPackage.package.isCask)
                            })
                    case .isExecuting(_, _):
                        ProgressView(value: updateProgress, total: Double(selectedPackages.count)) {
                            Text("update-packages.incremental.update-in-progress-\(outdatedPackage.package.name)")
                        }
                        .frame(width: 200)
                    case .executed(_):
                        if !viewModel.nextStep(index: &index, max: selectedPackages.count, updateProgress: &updateProgress) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.seal")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.secondary)
                                if viewModel.packageUpdatingErrors.count == 0 {
                                    VStack(alignment: .leading) {
                                        Text("update-packages.incremental.finished")
                                            .font(.headline)
                                        Text("update-packages.finished.description")
                                    }
                                    .fixedSize()
                                } else {
                                    VStack(alignment: .leading, spacing: 5) {
                                        VStack(alignment: .leading) {
                                            Text("update-packages.error")
                                                .font(.headline)
                                            Text("update-packages.error.description")
                                        }
                                        List {
                                            ForEach(viewModel.packageUpdatingErrors, id: \.self) { error in
                                                HStack(alignment: .firstTextBaseline, spacing: 5) {
                                                    Text("⚠️")
                                                    Text(error)
                                                }
                                            }
                                        }
                                        .listStyle(.bordered(alternatesRowBackgrounds: false))
                                        .frame(height: 100, alignment: .leading)
                                        HStack {
                                            Spacer()
                                            Button {
                                                viewStore.send(.goBackTapped)
                                            } label: {
                                                Text("action.close")
                                            }
                                            .keyboardShortcut(.cancelAction)
                                        }
                                    }
                                    .fixedSize()
                                }
                            }
                            .onAppear(perform: {
                                if viewModel.packageUpdatingErrors.count == 0 {
                                    Delay(10).performWork {
                                        viewStore.send(.goBackTapped)
                                    }
                                }
                                outdatedPackageTracker.outdatedPackages = viewModel.removeUpdatedPackages(outdatedPackageTracker: outdatedPackageTracker, namesOfUpdatedPackages: selectedPackages.map(\.package.name))
                            })
                        }
                    case .failed(let error):
                        if !viewModel.nextStepWithError(index: &index, max: selectedPackages.count, updateProgress: &updateProgress, error: error) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.seal")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.secondary)
                                VStack(alignment: .leading, spacing: 5) {
                                    VStack(alignment: .leading) {
                                        Text("update-packages.error")
                                            .font(.headline)
                                        Text("update-packages.error.description")
                                    }
                                    List {
                                        ForEach(viewModel.packageUpdatingErrors, id: \.self) { error in
                                            HStack(alignment: .firstTextBaseline, spacing: 5) {
                                                Text("⚠️")
                                                Text(error)
                                            }
                                        }
                                    }
                                    .listStyle(.bordered(alternatesRowBackgrounds: false))
                                    .frame(height: 100, alignment: .leading)
                                    HStack {
                                        Spacer()
                                        Button {
                                            viewStore.send(.goBackTapped)
                                        } label: {
                                            Text("action.close")
                                        }
                                        .keyboardShortcut(.cancelAction)
                                    }
                                }
                                .fixedSize()
                            }
                            .onAppear(perform: {
                                outdatedPackageTracker.outdatedPackages = viewModel.removeUpdatedPackages(outdatedPackageTracker: outdatedPackageTracker, namesOfUpdatedPackages: selectedPackages.map(\.package.name))
                            })
                    }
                }
            }
        }
    }
}

/*#Preview {
    IncrementalPackagesUpdateView()
}*/
