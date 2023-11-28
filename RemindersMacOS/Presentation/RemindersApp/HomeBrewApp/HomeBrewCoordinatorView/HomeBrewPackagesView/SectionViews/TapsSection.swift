//
//  HomeBrewPackagesViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import SwiftUI
import Reminders_Domain

struct TapsSection: View {
    @StateObject var homeBrewMainVM: HomeBrewMainViewModel
    
    var body: some View {
        Section("sidebar.section.added-taps") {
            switch homeBrewMainVM.homeBrewTaps {
            case .notRequested:
                Text("").onAppear(perform: homeBrewMainVM.loadTaps )
            case let .isLoading(last, _):
                if let taps = last {
                    AnyView(loadedTapsView(taps))
                } else {
                    AnyView(ProgressView().padding())
                }
            case let .loaded(installedTaps):
                loadedTapsView(installedTaps)
            case let .failed(error):
                ErrorView(error: error, retryAction: homeBrewMainVM.loadTaps)
            }
        }
        .collapsible(false)
    }
    
    func loadedTapsView(_ taps: [BrewTap]) -> some View {
        let filteredTaps: [BrewTap] = Array(homeBrewMainVM.brewData.addedTaps.filter( { tap in homeBrewMainVM.isTapIncluded(tap) } ))
        return ForEach(filteredTaps, id: \.id) { tap in
            NavigationLink() {
                let tapDetailViewModel: TapDetailViewModel = DIContainer.shared.resolve(argument: tap.name)
                TapDetailView(viewModel: tapDetailViewModel) //, homeBrewMainVM: homeBrewMainVM) //{ tapName in
                 //   homeBrewMainVM.uninstall(packageName: tapName, tracker: .tap)
                //}
            } label: {
                if tap.isBeingModified {
                    switch homeBrewMainVM.actionSuccess {
                    case .notRequested:
                        Text(tap.name)
                    case .isExecuting(_, _):
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text(tap.name)
                            Spacer()
                            ProgressView()
                                .frame(height: 5)
                                .scaleEffect(0.5)
                        }
                    case .executed(_):
                        uninstallTapExecutedView(tapName: tap.name)
                    case .failed(_):
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text(tap.name)
                            Spacer()
                            Image(systemName: "error")
                        }
                    }
                } else if tap.hasError {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text(tap.name)
                        Spacer()
                        Image(systemName: "error")
                    }
                } else {
                    Text(tap.name)
                }
            }
            .contextMenu {
                Button {
                    homeBrewMainVM.uninstall(packageName: tap.name, tracker: .tap)
                } label: {
                    Text("sidebar.section.added-taps.contextmenu.remove-\(tap.name)")
                }
            }
        }
    }
    
    func uninstallTapExecutedView(tapName: String) -> some View {
        return HStack {
            Text(tapName)
            Spacer()
            Image(systemName: "x")
        }
    }
}
