//
//  PackagesSection.swift
//  RemindersMacOS
//
//  Created by Thomas on 12.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackagesSection: View {
    @AppStorage("allowMoreCompleteUninstallations") var allowMoreCompleteUninstallations: Bool = false
    @AppStorage("sortPackagesBy") var sortPackagesBy: PackageSortingOptions = .none
    @StateObject var homeBrewMainVM: HomeBrewMainViewModel
    var isCask: Bool
    
    var body: some View {
        Section(isCask ? "sidebar.section.installed-casks" : "sidebar.section.installed-formulae") {
            switch isCask ? homeBrewMainVM.homeBrewCasks : homeBrewMainVM.homeBrewFormulae {
            case .notRequested:
                Text("").onAppear(perform: isCask ? homeBrewMainVM.loadCasks : homeBrewMainVM.loadFormulae )
            case let .isLoading(last, _):
                loadingPackagesView(last)
            case let .loaded(installedPackages):
                loadedPackagesView(installedPackages)
            case let .failed(error):
                ErrorView(error: error, retryAction: isCask ? homeBrewMainVM.loadCasks : homeBrewMainVM.loadFormulae)
            }
        }
        .collapsible(false)
    }

    func loadingPackagesView(_ previouslyLoaded: [BrewPackage]?) -> some View {
        if let homeBrewPackages = previouslyLoaded {
            return AnyView(loadedPackagesView(homeBrewPackages))
        } else {
            return AnyView(ProgressView().padding())
        }
    }
    
    func loadedPackagesView(_ packages: [BrewPackage]) -> some View {
        let filteredPackages = Array(isCask ? homeBrewMainVM.brewData.installedCasks.filter( { cask in homeBrewMainVM.isCaskIncluded(cask) } ) : homeBrewMainVM.brewData.installedFormulae.filter( { formula in homeBrewMainVM.isFormulaIncluded(formula)} )).sorted(by: sortPackagesBy.sortComparator)
        return ForEach(filteredPackages, id: \.id) { package in
            NavigationLink() {
                let packageDetailViewModel: PackageDetailViewModel = DIContainer.shared.resolve(argument: package)
                PackageDetailView(viewModel: packageDetailViewModel)
            } label: {
                PackageListItem(package: package)
            }
            .contextMenu {
                Button {
                    homeBrewMainVM.changeTaggedStatus(packageName: package.name, tracker: isCask ? .cask : .formula)
                } label: {
                    Text(package.isTagged ? "sidebar.section.all.contextmenu.untag-\(package.name)" : "sidebar.section.all.contextmenu.tag-\(package.name)")
                }
                Divider()
                Button {
                    homeBrewMainVM.uninstall(packageName: package.name, tracker: package.isCask ? .cask : .formula, shouldRemoveAllAssociatedFiles: false)
                } label: {
                    Text(package.isCask ? "sidebar.section.installed-formulae.contextmenu.uninstall-\(package.name)" : "sidebar.section.installed-casks.contextmenu.uninstall-\(package.name)")
                }
                if allowMoreCompleteUninstallations {
                    Button {
                        homeBrewMainVM.uninstall(packageName: package.name, tracker: package.isCask ? .cask : .formula, shouldRemoveAllAssociatedFiles: true)
                    } label: {
                        Text("sidebar.section.installed-formulae.contextmenu.uninstall-deep-\(package.name)")
                    }
                }
            }
        }
    }
}

/*#Preview {
    LoadedPackageView()
}*/
