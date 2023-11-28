//
//  TapDetailView.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import SwiftUI
import Combine
import Reminders_Domain

struct TapDetailView: View {
    @StateObject var viewModel: TapDetailViewModel
    @EnvironmentObject var homeBrewMainVM: HomeBrewMainViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center, spacing: 5) {
                    Text(viewModel.brewTapName)
                        .font(.title)
                    if viewModel.state.isOfficial ?? false {
                        Image(systemName: "checkmark.shield")
                            .help("tap-details.official-\(viewModel.brewTapName)")
                    }
                }
            }
            switch viewModel.state.homeBrewTapInfo {
            case .notRequested:
                Text("").onAppear(perform:  viewModel.loadTapInfo )
            case .isLoading(_, _):
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        ProgressView {
                            Text("tap-details.loading")
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            case let .loaded(selectedTapInfo):
                loadedTapInfoView(selectedTapInfo)
            case let .failed(error):
                ErrorView(error: error, retryAction: viewModel.loadTapInfo )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func loadedTapInfoView(_ homeBrewTapInfo: BrewTapInfo) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            Text("tap-details.info")
                .font(.title2)
            TapDetailIncludedPackagesView(includedFormulae: viewModel.state.availableFormulae, includedCasks: viewModel.state.availableCasks, homePage: viewModel.state.homePage ?? URL(fileURLWithPath: "https://google.com"))
            if viewModel.state.availableFormulae != nil || viewModel.state.availableCasks != nil {
                TapDetailsIncludedPackagesDetailView(includedFormulae: viewModel.state.availableFormulae, includedCasks: viewModel.state.availableCasks, installedFormulae: homeBrewMainVM.brewData.installedFormulae.map( { $0.name } ), installedCasks: homeBrewMainVM.brewData.installedCasks.map( { $0.name } ))
            }
            Spacer()
            switch homeBrewMainVM.actionSuccess {
            case .notRequested, .executed(_), .failed(_):
                uninstallTapsButton(false)
            case .isExecuting(_, _):
                uninstallTapsButton(true)
            }
        }
    }
    
    func uninstallTapsButton( _ isBeingModified: Bool) -> some View {
        HStack(alignment: .center) {
            Spacer()
            if isBeingModified {
                ProgressView()
                    .scaleEffect(0.5, anchor: .center)
                    .frame(width: 1, height: 1)
            }
            Button {
                homeBrewMainVM.uninstall(packageName: viewModel.brewTapName, tracker: .tap)
            } label: {
                Text("tap-details.remove-\(viewModel.brewTapName)")
            }
            .disabled(isBeingModified)
        }
        .padding()
    }
}


/*#Preview {
    TapDetailView()
}*/
