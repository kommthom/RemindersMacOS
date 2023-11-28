//
//  HomeBrewCoordinatorView.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct HomeBrewCoordinatorView: View {
      let store: StoreOf<HomeBrewCoordinator>

      var body: some View {
            TCARouter(store) { screen in
                  SwitchStore(screen) { screen in
                      switch screen {
                      case .homeBrew:
                          CaseLet(
                            /HomeBrewScreen.State.homeBrew,
                             action: HomeBrewScreen.Action.homeBrew,
                             then: HomeBrewSideBarView.init(store: )
                          )
                      case .maintenance:
                          CaseLet(
                            /HomeBrewScreen.State.maintenance,
                             action: HomeBrewScreen.Action.maintenance,
                             then: MaintenanceView.init(store: )
                          )
                      case .maintenanceRunning:
                          CaseLet(
                            /HomeBrewScreen.State.maintenanceRunning,
                             action: HomeBrewScreen.Action.maintenanceRunning,
                             then: MaintenanceRunningView.init(store: )
                          )
                      case .maintenanceFinished:
                          CaseLet(
                            /HomeBrewScreen.State.maintenanceFinished,
                             action: HomeBrewScreen.Action.maintenanceFinished,
                             then: MaintenanceFinishedView.init(store: )
                          )
                      case .addTap:
                          CaseLet(
                              /HomeBrewScreen.State.addTap,
                               action: HomeBrewScreen.Action.addTap,
                               then: AddTapView.init(store: )
                           )
                      case .addTapRunning:
                          CaseLet(
                              /HomeBrewScreen.State.addTapRunning,
                               action: HomeBrewScreen.Action.addTapRunning,
                               then: AddTapRunningView.init(store: )
                           )
                      case .addTapFinished:
                          CaseLet(
                              /HomeBrewScreen.State.addTapFinished,
                               action: HomeBrewScreen.Action.addTapFinished,
                               then: AddTapFinishedView.init(store: )
                           )
                      case .installPackage:
                          CaseLet(
                              /HomeBrewScreen.State.installPackage,
                               action: HomeBrewScreen.Action.installPackage,
                               then: InstallPackageView.init(store: )
                           )
                      case .installPackageSearching:
                          CaseLet(
                              /HomeBrewScreen.State.installPackageSearching,
                               action: HomeBrewScreen.Action.installPackageSearching,
                               then: InstallPackageSearchingView.init(store: )
                           )
                      case .installPackageRunning:
                          CaseLet(
                              /HomeBrewScreen.State.installPackageRunning,
                               action: HomeBrewScreen.Action.installPackageRunning,
                               then: InstallPackageRunningView.init(store: )
                           )
                      case .packagesUpdate:
                          CaseLet(
                              /HomeBrewScreen.State.packagesUpdate,
                               action: HomeBrewScreen.Action.packagesUpdate,
                               then: PackagesUpdateView.init(store: )
                           )
                      case .incrementalPackagesUpdate:
                          CaseLet(
                              /HomeBrewScreen.State.incrementalPackagesUpdate,
                               action: HomeBrewScreen.Action.incrementalPackagesUpdate,
                               then: IncrementalPackagesUpdateView.init(store: )
                           )
                      }
                  }
            }
      }
}

/*#Preview {
    HomeBrewCoordinatorView()
}*/
