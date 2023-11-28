//
//  InformationView.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import SwiftUI
import Reminders_Domain

struct InformationView: View {
    @EnvironmentObject var homeBrewMainVM: HomeBrewMainViewModel
    var onButtonTapped: (_ buttonTapped: ButtonTapped) -> Void
    @State private var isOutdatedPackageDropdownExpanded: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Form {
                    if homeBrewMainVM.hasLoadedFormulae && homeBrewMainVM.hasLoadedCasks && homeBrewMainVM.hasLoadedTaps {
                        Section {
                            switch homeBrewMainVM.outdatedPackages {
                            case .notRequested:
                                Text("Waiting...").onAppear(perform: homeBrewMainVM.loadOutdatedPackages )
                            case .isLoading(_, _):
                                Grid {
                                    GridRow(alignment: .firstTextBaseline) {
                                        HStack(alignment: .center, spacing: 15) {
                                            ProgressView()
                                            Text("start-page.updates.loading")
                                        }
                                        .padding(10)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                }
                            case let .loaded(outdatedPackages):
                                if outdatedPackages.count == 0 {
                                    AnyView(Text("start-page.updates.notavailable"))
                                } else {
                                    AnyView(
                                        OutdatedPackagesView(homeBrewMainVM: homeBrewMainVM, isDropdownExpanded: $isOutdatedPackageDropdownExpanded) { buttonTapped in
                                            onButtonTapped(buttonTapped)
                                        }
                                            .transition(.move(edge: .top)
                                                .animation(.easeIn)))
                                }
                            case let .failed(error):
                                ErrorView(error: error, retryAction: homeBrewMainVM.loadOutdatedPackages )
                            }
                        } header: {
                            Text("start-page.status")
                                .font(.title)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                        Section {
                            PackageAndTapOverview(formulaeCount: homeBrewMainVM.brewData.installedFormulae.count, casksCount: homeBrewMainVM.brewData.installedCasks.count, tapsCount: homeBrewMainVM.brewData.addedTaps.count)
                        }
                        Section {
                            AnalyticsStatusView()
                        }
                    } else {
                        ProgressView("start-page.loading")
                    }
                    if homeBrewMainVM.cachedDownloadsFolderSize != 0 {
                        Section {
                            CachedDownloadsFolderInfoView(cachedDownloadsFolderSize: homeBrewMainVM.cachedDownloadsFolderSize) { buttonTapped in
                                onButtonTapped(buttonTapped)
                            }
                        }
                    }
                }
                .scrollDisabled(!isOutdatedPackageDropdownExpanded)
                .formStyle(.grouped)
                .frame(minWidth: 300, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                Spacer()
                HStack(alignment: .center) {
                    HStack {
                        Spacer()
                        Button {
                            AppLogger.homeBrew.log("Would perform maintenance")
                            onButtonTapped(.maintenance)
                        } label: {
                            Text("start-page.open-maintenance")
                        }
                        .disabled(!(homeBrewMainVM.hasLoadedFormulae && homeBrewMainVM.hasLoadedCasks && homeBrewMainVM.hasLoadedTaps))
                    }
                }
                .padding()
            }
        }
    }
}

/*#Preview {
    InformationView()
}*/
