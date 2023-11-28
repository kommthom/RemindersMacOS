//
//  HomeBrewSideBarView.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import SwiftUI
import Combine
import ComposableArchitecture
import Reminders_Domain
import Reminders_Brew

enum ButtonTapped {
    case maintenance
    case incrementalUpdate
    case updateAll
    case fastCacheDeletion
    case installPackage
}

struct HomeBrewSideBarView: View {
    let store: StoreOf<HomeBrewPackages>
    
    @EnvironmentObject var homeBrewMainVM: HomeBrewMainViewModel
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    init(store: StoreOf<HomeBrewPackages>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            NavigationSplitView(columnVisibility: $columnVisibility)  {
                List {
                    NavigationSection() { buttonTapped in
                        viewStore.send(translateButtonTapped(buttonTapped))
                    }
                    if homeBrewMainVM.showFormulae() {
                        PackagesSection(homeBrewMainVM: homeBrewMainVM, isCask: false)
                    }
                    if homeBrewMainVM.showCasks() {
                        PackagesSection(homeBrewMainVM: homeBrewMainVM, isCask: true)
                    }
                    if homeBrewMainVM.showTaps() {
                        TapsSection(homeBrewMainVM: homeBrewMainVM)
                    }
                }
                .listStyle(.sidebar)
                .searchable(text: $homeBrewMainVM.state.searchText,
                            tokens: $homeBrewMainVM.state.currentTokens,
                            suggestedTokens: .constant(homeBrewMainVM.state.suggestedTokens()),
                            placement: .sidebar,
                            prompt: Text("sidebar.search.prompt")) { token in
                                Label {
                                    Text(token.name)
                                } icon: {
                                    Image(systemName: token.icon)
                                        .foregroundColor(Color.blue)
                                }
                            }
                .frame(minWidth: Geometries.main.sidebarWidth[AppSection.homeBrew.rawValue], minHeight: Geometries.main.content[AppSection.homeBrew.rawValue].height)
            } detail: {
                InformationView() { buttonTapped in
                    viewStore.send(translateButtonTapped(buttonTapped))
                }
                .frame(minWidth: Geometries.main.detailWidth[AppSection.homeBrew.rawValue], maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.homeBrew.rawValue].height, maxHeight: .infinity)
            }
            .navigationTitle("app-name" + ":" + "app-section-homebrew")
            .navigationSubtitle("navigation.installed-packages.count-\(homeBrewMainVM.brewData.installedFormulae.count + homeBrewMainVM.brewData.installedCasks.count)")
            .toolbar(id: "PackageActions") {
                HomeBrewToolbar(upgradeDisabled: homeBrewMainVM.brewData.outdatedPackages.count == 0) { buttonTapped in
                    viewStore.send(buttonTapped)
                }
            }
            .onAppear(perform: {
                homeBrewMainVM.homeBrewInitCheck()
            })
        }
    }
    
    func translateButtonTapped(_ buttonTapped: ButtonTapped) -> HomeBrewPackages.Action {
        switch buttonTapped {
             case .maintenance:
                .maintenanceButtonTapped(false)
             case .incrementalUpdate:
                .incrementalPackagesUpdateTapped
             case .updateAll:
                .packagesUpdateTapped
             case .fastCacheDeletion:
                .maintenanceButtonTapped(true)
             case .installPackage:
                .installPackageTapped
         }
    }
}

#Preview {
    HomeBrewSideBarView(store: ComposableArchitecture.Store(initialState: .init()) {
        HomeBrewPackages()
    })
}
