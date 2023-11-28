//
//  InstallPackageRunningView.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain
import Reminders_Brew

struct InstallPackageRunningView: View {
    let store: StoreOf<InstallPackageRunning>
    
    @AppStorage("showPackagesStillLeftToInstall") var showPackagesStillLeftToInstall: Bool = false
    @AppStorage("notifyAboutPackageInstallationResults") var notifyAboutPackageInstallationResults: Bool = false
    @EnvironmentObject var homeBrewState: HomeBrewState
    @EnvironmentObject var brewData: BrewDataStorage
    @ObservedObject var installationProgressTracker: InstallationProgressTracker = .init()
    @StateObject var viewModel: InstallPackageRunningViewModel = DIContainer.shared.resolve()
    @State var isShowingRealTimeOutput: Bool = false
    @State var searchText: String = ""
    
    init(store: StoreOf<InstallPackageRunning>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                switch viewModel.foundPackages {
                case .notRequested:
                    notRequestedPackagesInstallingView
                case .isLoading(let last, _):
                    installingPackagesView(last)
                        .frame(minHeight: 200)
                case .loaded(_):
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.seal")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.secondary)
                        VStack(alignment: .leading) {
                            Text("add-package.finished")
                                .font(.headline)
                            Text("add-package.finished.description")
                        }
                    }
                    .onAppear {
                        Delay(3).performWork {
                            viewStore.send(.goBackToRootTapped)
                        }
                        homeBrewState.cachedDownloadsFolderSize = directorySize(url: HomeBrewConstants.brewCachedDownloadsPath)
                        if notifyAboutPackageInstallationResults {
                            sendNotification(title: String(localized: "notification.install-finished"))
                        }
                    }
                case .failed(_):
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.secondary)
                            if let packageBeingInstalled = installationProgressTracker.packagesBeingInstalled.first { /// Show this when we can pull out which package was being installed
                                VStack(alignment: .leading) {
                                    Text("add-package.fatal-error-\(packageBeingInstalled.package.name)")
                                        .font(.headline)
                                    Text("add-package.fatal-error.description")
                                }
                            } else { /// Otherwise, show a generic error
                                VStack(alignment: .leading) {
                                    Text("add-package.fatal-error.generic")
                                        .font(.headline)
                                    Text("add-package.fatal-error.description")
                                }
                            }
                        }
                        HStack {
                            Button {
                                restartApp()
                            } label: {
                                Text("action.restart")
                            }
                            Spacer()
                            Button {
                                viewStore.send(.goBackToRootTapped)
                            } label: {
                                Text("action.cancel")
                            }
                            .keyboardShortcut(.cancelAction)
                        }
                    }
                }
            }
        }
    }
    
    var notRequestedPackagesInstallingView: some View {
        Text("").onAppear(perform: { viewModel.load(searchText: searchText) } )
    }
    
    func installingPackagesView(_ previouslyLoaded: [String]?) -> some View {
        VStack(alignment: .leading) {
            ForEach(installationProgressTracker.packagesBeingInstalled) { packageBeingInstalled in
                if packageBeingInstalled.installationStage != .finished {
                    ProgressView(value: installationProgressTracker.packagesBeingInstalled[0].packageInstallationProgress, total: 10) {
                        VStack(alignment: .leading) {
                            switch packageBeingInstalled.installationStage {
                            case .ready:
                                Text("add-package.install.ready")
                                // FORMULAE
                            case .loadingDependencies:
                                Text("add-package.install.loading-dependencies")
                            case .fetchingDependencies:
                                Text("add-package.install.fetching-dependencies")
                            case .installingDependencies:
                                Text("add-package.install.installing-dependencies-\(installationProgressTracker.numberInLineOfPackageCurrentlyBeingInstalled)-of-\(installationProgressTracker.numberOfPackageDependencies)")
                            case .installingPackage:
                                Text("add-package.install.installing-package")
                            case .finished:
                                Text("add-package.install.finished")
                                // CASKS
                            case .downloadingCask:
                                Text("add-package.install.downloading-cask-\(installationProgressTracker.packagesBeingInstalled[0].package.name)")
                            case .installingCask:
                                Text("add-package.install.installing-cask-\(installationProgressTracker.packagesBeingInstalled[0].package.name)")
                            case .linkingCaskBinary:
                                Text("add-package.install.linking-cask-binary")
                            case .movingCask:
                                Text("add-package.install.moving-cask-\(installationProgressTracker.packagesBeingInstalled[0].package.name)")
                            case .requiresSudoPassword:
                                Text("add-package.install.requires-sudo-password-\(installationProgressTracker.packagesBeingInstalled[0].package.name)")
                                    .onAppear {
                                        //packageInstallationProcessStep = .requiresSudoPassword
                                    }
                            }
                            LiveTerminalOutputView(
                                lineArray: $installationProgressTracker.packagesBeingInstalled[0].realTimeTerminalOutput,
                                isRealTimeTerminalOutputExpanded: $isShowingRealTimeOutput
                            )
                        }
                        .fixedSize()
                    }
                    //deprecated .animation(.none)
                } else { // Show this when the installation is finished
                    Text("add-package.install.finished")
                        .onAppear {
                            //packageInstallationProcessStep = .finished
                        }
                }
            }
        }
    }
}

/*#Preview {
    InstallPackageRunningView()
}*/
