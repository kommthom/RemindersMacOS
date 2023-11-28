//
//  PackageDetailButtons.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageDetailButtons: View {
    @AppStorage("allowMoreCompleteUninstallations") var allowMoreCompleteUninstallations: Bool = false
    @StateObject var viewModel: PackageDetailViewModel
    @EnvironmentObject var homeBrewMainVM: HomeBrewMainViewModel

    var body: some View {
        VStack {
            HStack {
                if !viewModel.isCask {
                    Button {
                        homeBrewMainVM.actionType = .pinUnpin(viewModel.brewPackageName)
                        viewModel.pinAndUnpinPackage()
                    } label: {
                        Text(viewModel.state.pinned ?? false ? "package-details.action.unpin-version-\(viewModel.versions.joined())" : "package-details.action.pin-version-\(viewModel.versions.joined())")
                    }
                }
                
                switch homeBrewMainVM.isHandledByMainVM() ? homeBrewMainVM.actionSuccess : viewModel.state.pinAndUnpinSuccess {
                case .notRequested:
                    Spacer()
                case .isExecuting(_, _):
                    Spacer()
                    ProgressView()
                        .scaleEffect(0.5, anchor: .center)
                        .frame(width: 1, height: 1)
                case .executed(_):
                    Spacer()
                case .failed(let error):
                    Spacer()
                    ErrorView(error: error) {
                        switch homeBrewMainVM.actionType {
                        case .pinUnpin(_):
                            return viewModel.pinAndUnpinPackage()
                        default:
                            return homeBrewMainVM.uninstall(packageName: viewModel.brewPackageName, tracker: viewModel.isCask ? .cask : .formula)
                        }
                    }
                }
                HStack(spacing: 15) {
                    if allowMoreCompleteUninstallations {
                        Spacer()
                        Menu {
                            Button(role: .destructive) {
                                homeBrewMainVM.uninstall(packageName: viewModel.brewPackageName, tracker: viewModel.isCask ? .cask : .formula, shouldRemoveAllAssociatedFiles: true)
                            } label: {
                                Text("package-details.action.uninstall-deep-\(viewModel.brewPackageName)")
                            }
                        } label: {
                            Text("package-details.action.uninstall-\(viewModel.brewPackageName)")
                        } primaryAction: {
                            homeBrewMainVM.uninstall(packageName: viewModel.brewPackageName, tracker: viewModel.isCask ? .cask : .formula, shouldRemoveAllAssociatedFiles: false)
                        }
                        .fixedSize()
                    } else {
                        Button(role: .destructive) {
                            homeBrewMainVM.uninstall(packageName: viewModel.brewPackageName, tracker: viewModel.isCask ? .cask : .formula, shouldRemoveAllAssociatedFiles: false)
                        } label: {
                            Text("package-details.action.uninstall-\(viewModel.brewPackageName)")
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
    PackageDetailButtons()
}*/
