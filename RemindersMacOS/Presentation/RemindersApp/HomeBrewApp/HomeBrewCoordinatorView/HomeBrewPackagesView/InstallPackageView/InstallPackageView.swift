//
//  InstallPackageView.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain
import Reminders_Brew

struct InstallPackageView: View {
    let store: StoreOf<InstallPackageReducer>
    @AppStorage("enableDiscoverability") var enableDiscoverability: Bool = false
    @EnvironmentObject var topPackagesTracker: TopPackagesTracker
    @State private var foundPackageSelection = Set<UUID>()
    @State private var searchText: String = ""
    @FocusState var isSearchFieldFocused: Bool
    @Inject private var topFormulaeViewModel: TopFormulaeViewModel
    @Inject private var topCasksViewModel: TopCasksViewModel
    @ObservedObject var installationProgressTracker = InstallationProgressTracker()
    
    init(store: StoreOf<InstallPackageReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("add-package.title")
                        .font(.headline)
                    VStack {
                        if enableDiscoverability {
                            List(selection: $foundPackageSelection) {
                                TopPackagesSection(viewModel: topFormulaeViewModel, isCaskTracker: false)
                                TopPackagesSection(viewModel: topCasksViewModel, isCaskTracker: true)
                            }
                            .listStyle(.bordered(alternatesRowBackgrounds: true))
                            .frame(minHeight: 200)
                        }
                        TextField("add-package.search.prompt", text: $searchText) { _ in
                            foundPackageSelection = Set<UUID>() // Clear all selected items when the user looks for a different package
                        }
                        .focused($isSearchFieldFocused)
                        .onAppear {
                            isSearchFieldFocused.toggle()
                        }
                        HStack {
                            Button {
                                viewStore.send(.goBackTapped)
                            } label: {
                                Text("action.cancel")
                            }
                            .keyboardShortcut(.cancelAction)
                            Spacer()
                            if enableDiscoverability {
                                Button {
                                    var selectedTopPackageIsCask: Bool {
                                        // If this UUID is in the top casks tracker, it means it's a cask. Otherwise, it's a formula. So we test if the result of looking for the selected package in the cask tracker returns nothing; if it does return nothing, it's a formula (since the package is not in the cask tracker)
                                        if Set(topPackagesTracker.topCasks).filter({ $0.id == foundPackageSelection.first }).isEmpty {
                                            return false
                                        } else {
                                            return true
                                        }
                                    }
                                    do {
                                        let packageToInstall: BrewPackage = try getTopPackageFromUUID(requestedPackageUUID: foundPackageSelection.first!, isCask: selectedTopPackageIsCask, topPackageTracker: topPackagesTracker)
                                        installationProgressTracker.packagesBeingInstalled.append(PackageInProgressOfBeingInstalled(package: packageToInstall, installationStage: .ready, packageInstallationProgress: 0))
                                        installationProgressTracker.packageBeingCurrentlyInstalled = packageToInstall.name
                                        viewStore.send(.startInstallationButtonTapped)
                                    } catch let topPackageInstallationError {
                                        AppLogger.homeBrew.log("Failet while trying to get top package to install: \(topPackageInstallationError)")
                                        viewStore.send(.goBackTapped)
                                        //appState.fatalAlertType = .topPackageArrayFilterCouldNotRetrieveAnyPackages
                                        //appState.isShowingFatalError = true
                                    }
                                    
                                } label: {
                                    Text("add-package.install.action")
                                }
                                .keyboardShortcut(!foundPackageSelection.isEmpty ? .defaultAction : .init(.end))
                                .disabled(foundPackageSelection.isEmpty)
                            }
                            Button {
                                viewStore.send(.startSearchingButtonTapped(searchText: searchText))
                            } label: {
                                Text("add-package.search.action")
                            }
                            .keyboardShortcut(foundPackageSelection.isEmpty ? .defaultAction : .init(.end))
                            .disabled(searchText.isEmpty)
                        }
                    }
                    .onAppear {
                        foundPackageSelection = .init()
                    }
                }
                .frame(minWidth: 300)
            }
            .padding()
        }
    }
}

/*#Preview {
    InstallPackageView()
}*/
