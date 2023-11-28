//
//  HomeBrewCoordinator.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

struct HomeBrewCoordinator: Reducer {
    struct State: Equatable, IdentifiedRouterState {
        static let initialState = State(
            routes: [.root(.homeBrew(.init()), embedInNavigationView: false)]
        )
        var routes: IdentifiedArrayOf<Route<HomeBrewScreen.State>>
        //var routes: [Route<HomeBrewScreen.State>]
    }

    enum Action: IdentifiedRouterAction {
        case routeAction(HomeBrewScreen.State.ID, action: HomeBrewScreen.Action)
        case updateRoutes(IdentifiedArrayOf<Route<HomeBrewScreen.State>>)
        //case routeAction(Int, action: HomeBrewScreen.Action)
        //case updateRoutes([Route<HomeBrewScreen.State>])
    }

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .routeAction(_, .homeBrew(.maintenanceButtonTapped(let fastCacheDeletion))):
                state.routes.presentSheet(.maintenance(.init(fastCacheDeletion: fastCacheDeletion)), embedInNavigationView: false)
           
            case .routeAction(_, .maintenanceRunning(.maintenanceFinishedButtonTapped(let maintenanceResultStates))):
                state.routes.presentSheet(.maintenanceFinished(.init(maintenanceResultStates: maintenanceResultStates)), embedInNavigationView: false)
                
            case .routeAction(_, .maintenance(.maintenanceRunningButtonTapped(let shouldUninstallOrphans, let shouldPurgeCache, let shouldDeleteDownloads, let shouldPerformHealthCheck))):
                state.routes.presentSheet(.maintenanceRunning(.init(shouldUninstallOrphans: shouldUninstallOrphans, shouldPurgeCache: shouldPurgeCache, shouldDeleteDownloads: shouldDeleteDownloads, shouldPerformHealthCheck: shouldPerformHealthCheck)), embedInNavigationView: false)
                
            case .routeAction(_, .homeBrew(.addTapTapped)):
                state.routes.presentSheet(.addTap(.init()), embedInNavigationView: false)
                
            case .routeAction(_, .addTap(.addTapRunningButtonTapped(let tapName))):
                state.routes.presentSheet(.addTapRunning(.init(tapName: tapName)), embedInNavigationView: false)
                
            case .routeAction(_, .addTapRunning(.addTapFinishedButtonTapped(let tapName, let success))):
                state.routes.presentSheet(.addTapFinished(.init(success: success, tapName: tapName)), embedInNavigationView: false)
                
            case .routeAction(_, .homeBrew(.installPackageTapped)):
                state.routes.presentSheet(.installPackage(.init()), embedInNavigationView: false)
                
            case .routeAction(_, .homeBrew(.packagesUpdateTapped)):
                state.routes.presentSheet(.packagesUpdate(.init()), embedInNavigationView: false)
                
            case .routeAction(_, .installPackage(.startInstallationButtonTapped)):
                state.routes.presentSheet(.installPackageRunning(.init()), embedInNavigationView: false)
                
            case .routeAction(_, .installPackage(.startSearchingButtonTapped(searchText: let searchText))):
                state.routes.presentSheet(.installPackageSearching(.init(searchText: searchText)), embedInNavigationView: false)
                
            case .routeAction(_, .homeBrew(.incrementalPackagesUpdateTapped)):
                state.routes.presentSheet(.incrementalPackagesUpdate(.init()), embedInNavigationView: false)
                
            case .routeAction(_, .maintenance(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .maintenanceRunning(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .maintenanceFinished(.goBackTapped)):
                state.routes.goBack()

            case .routeAction(_, .maintenanceFinished(.goBackToRootTapped)):
                return .routeWithDelaysIfUnsupported(state.routes) {
                  $0.goBackToRoot()
                }
                
            case .routeAction(_, .addTapFinished(.goBackToRootTapped)):
                return .routeWithDelaysIfUnsupported(state.routes) {
                  $0.goBackToRoot()
                }
                
            case .routeAction(_, .addTap(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .addTapRunning(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .addTapRunning(.goBackToRootTapped)):
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.goBackToRoot()
                }
                
            case .routeAction(_, .addTapFinished(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .installPackage(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .packagesUpdate(.goBackTapped)):
                state.routes.goBack()
                
            case .routeAction(_, .incrementalPackagesUpdate(.goBackTapped)):
                state.routes.goBack()

            default:
                break
            }
            return .none
        }

        .forEachRoute {
            HomeBrewScreen()
        }
    }
}

