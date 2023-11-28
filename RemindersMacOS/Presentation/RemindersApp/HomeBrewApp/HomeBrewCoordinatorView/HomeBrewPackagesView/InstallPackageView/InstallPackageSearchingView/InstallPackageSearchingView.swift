//
//  InstallPackageSearchingView.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain
import Reminders_Brew

struct InstallPackageSearchingView: View {
    let store: StoreOf<InstallPackageSearching>
    @Inject private var searchFormulaeViewModel: SearchFormulaeViewModel
    @Inject private var searchCasksViewModel: SearchCasksViewModel
    @State var searchText: String = ""
    @State var foundPackageSelection: Set<UUID> = Set<UUID>()
    @FocusState var isSearchFieldFocused: Bool
    @ObservedObject var searchResultTracker: SearchResultTracker = .init()
    @ObservedObject var installationProgressTracker: InstallationProgressTracker = .init()
    var loaded: [String] = .init()
    
    init(store: StoreOf<InstallPackageSearching>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    TextField("add-package.search.prompt", text: $searchText) { _ in
                        foundPackageSelection = Set<UUID>() // Clear all selected items when the user looks for a different package
                    }
                    .focused($isSearchFieldFocused)
                    .onAppear {
                        searchText = viewStore.state.searchText
                        isSearchFieldFocused = true
                    }
                    List(selection: $foundPackageSelection) {
                        SearchResultsSection(viewModel: searchFormulaeViewModel, searchText: $searchText, searchResultTracker: searchResultTracker)
                        SearchResultsSection(viewModel: searchCasksViewModel, searchText: $searchText, searchResultTracker: searchResultTracker)
                    }
                    .listStyle(.bordered(alternatesRowBackgrounds: true))
                    .frame(width: 300, height: 300)
                    HStack {
                        Button {
                            viewStore.send(.goBackToRootTapped)
                        } label: {
                            Text("action.cancel")
                        }
                        .keyboardShortcut(.cancelAction)
                        Spacer()
                        if isSearchFieldFocused {
                            Button { //new Search
                                searchFormulaeViewModel.foundPackages = .notRequested
                                searchCasksViewModel.foundPackages = .notRequested
                            } label: {
                                Text("add-package.search.action")
                            }
                            .keyboardShortcut(.defaultAction)
                            .disabled(viewStore.state.searchText.isEmpty || searchFormulaeViewModel.foundPackages != .loaded(loaded) || searchCasksViewModel.foundPackages != .loaded(loaded))
                        } else {
                            Button {
                                for requestedPackage in foundPackageSelection {
                                    do {
                                        let packageToInstall: BrewPackage = try getPackageFromUUID(requestedPackageUUID: requestedPackage, tracker: searchResultTracker)
                                        installationProgressTracker.packagesBeingInstalled.append(PackageInProgressOfBeingInstalled(package: packageToInstall, installationStage: .ready, packageInstallationProgress: 0))
                                        installationProgressTracker.packageBeingCurrentlyInstalled = packageToInstall.name
                                    } catch let packageByUUIDRetrievalError {
                                        AppLogger.homeBrew.log("Failed while associating package with its ID: \(packageByUUIDRetrievalError)")
                                       viewStore.send(.goBackToRootTapped)
                                        //appState.fatalAlertType = .couldNotAssociateAnyPackageWithProvidedPackageUUID
                                        //appState.isShowingFatalError = true
                                    }
                                }
                                viewStore.send(.startInstallationButtonTapped)
                            } label: {
                                Text("add-package.install.action")
                            }
                            .keyboardShortcut(.defaultAction)
                            .disabled(foundPackageSelection.isEmpty)
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
    InstallPackageSearchingView()
}*/
