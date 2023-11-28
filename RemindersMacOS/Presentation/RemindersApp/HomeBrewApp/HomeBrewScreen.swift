//
//  HomeBrewScreen.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct HomeBrewScreen: Reducer {
    enum State: Equatable, Identifiable {
        case homeBrew(HomeBrewPackages.State)
        case maintenance(Maintenance.State)
        case maintenanceRunning(MaintenanceRunning.State)
        case maintenanceFinished(MaintenanceFinished.State)
        case addTap(AddTap.State)
        case addTapRunning(AddTapRunning.State)
        case addTapFinished(AddTapFinished.State)
        case installPackage(InstallPackageReducer.State)
        case installPackageSearching(InstallPackageSearching.State)
        case installPackageRunning(InstallPackageRunning.State)
        case packagesUpdate(PackagesUpdate.State)
        case incrementalPackagesUpdate(IncrementalPackagesUpdate.State)
        
        var id: UUID {
            switch self {
            case .homeBrew(let state):
                return state.id
            case .maintenance(let state):
                return state.id
            case .maintenanceRunning(let state):
                return state.id
            case .maintenanceFinished(let state):
                return state.id
            case .addTap(let state):
                return state.id
            case .addTapRunning(let state):
                return state.id
            case .addTapFinished(let state):
                return state.id
            case .installPackage(let state):
                return state.id
            case .installPackageSearching(let state):
                return state.id
            case .installPackageRunning(let state):
                return state.id
            case .packagesUpdate(let state):
                return state.id
            case .incrementalPackagesUpdate(let state):
                return state.id
            }
        }
    }
        
    enum Action {
        case homeBrew(HomeBrewPackages.Action)
        case maintenance(Maintenance.Action)
        case maintenanceRunning(MaintenanceRunning.Action)
        case maintenanceFinished(MaintenanceFinished.Action)
        case addTap(AddTap.Action)
        case addTapRunning(AddTapRunning.Action)
        case addTapFinished(AddTapFinished.Action)
        case installPackage(InstallPackageReducer.Action)
        case installPackageSearching(InstallPackageSearching.Action)
        case installPackageRunning(InstallPackageRunning.Action)
        case packagesUpdate(PackagesUpdate.Action)
        case incrementalPackagesUpdate(IncrementalPackagesUpdate.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: /State.homeBrew, action: /Action.homeBrew) {
            HomeBrewPackages()
        }
        Scope(state: /State.maintenance, action: /Action.maintenance) {
            Maintenance()
        }
        Scope(state: /State.maintenanceRunning, action: /Action.maintenanceRunning) {
            MaintenanceRunning()
        }
        Scope(state: /State.maintenanceFinished, action: /Action.maintenanceFinished) {
            MaintenanceFinished()
        }
        Scope(state: /State.addTap, action: /Action.addTap) {
            AddTap()
        }
        Scope(state: /State.addTapRunning, action: /Action.addTapRunning) {
            AddTapRunning()
        }
        Scope(state: /State.addTapFinished, action: /Action.addTapFinished) {
            AddTapFinished()
        }
        Scope(state: /State.installPackage, action: /Action.installPackage) {
            InstallPackageReducer()
        }
        Scope(state: /State.installPackageSearching, action: /Action.installPackageSearching) {
            InstallPackageSearching()
        }
        Scope(state: /State.installPackageRunning, action: /Action.installPackageRunning) {
            InstallPackageRunning()
        }
        Scope(state: /State.packagesUpdate, action: /Action.packagesUpdate) {
            PackagesUpdate()
        }
        Scope(state: /State.incrementalPackagesUpdate, action: /Action.incrementalPackagesUpdate) {
            IncrementalPackagesUpdate()
        }
    }
}
