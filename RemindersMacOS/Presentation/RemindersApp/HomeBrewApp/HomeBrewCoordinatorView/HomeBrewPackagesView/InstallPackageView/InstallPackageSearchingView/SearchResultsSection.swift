//
//  SearchResultsSection.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import SwiftUI
import Reminders_Domain

struct SearchResultsSection: View {
    @StateObject var viewModel: SearchResultsViewModel
    @Binding var searchText: String
    @ObservedObject var searchResultTracker: SearchResultTracker
    
    var body: some View {
        switch viewModel.foundPackages {
        case .notRequested:
            notRequestedPackagesSearchingView
        case .isLoading(let last, _):
            loadingPackagesSearchingView(last)
                .frame(minHeight: 200)
        case .loaded(let foundPackages):
            loadedPackagesSearchingView(foundPackages)
        case .failed(let error):
            failedPackagesSearchingView(error)
        }
    }
    
    var notRequestedPackagesSearchingView: some View {
        Text("").onAppear(perform: { viewModel.load(searchText: searchText) } )
    }
    
    func loadingPackagesSearchingView(_ previouslyLoaded: [String]?) -> some View {
        if let foundPackages = previouslyLoaded {
            return AnyView(loadedPackagesSearchingView(foundPackages))
        } else {
            return AnyView(ProgressView("add-package.searching-\(searchText)"))
        }
    }
    
    func failedPackagesSearchingView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: { viewModel.load(searchText: searchText) } )
    }
    
    func loadedPackagesSearchingView( _ foundPackages: [String]) -> some View {
        @State var isSectionCollapsed: Bool = false
        var packages: [BrewPackage]

        if viewModel.isCask {
            searchResultTracker.foundCasks = []
            for cask in foundPackages {
                searchResultTracker.foundCasks.append(BrewPackage(name: cask, isCask: true, installedOn: nil, versions: [], sizeInBytes: nil))
            }
            packages = searchResultTracker.foundCasks
        } else {
            searchResultTracker.foundFormulae = []
            for formula in foundPackages {
                searchResultTracker.foundFormulae.append(BrewPackage(name: formula, isCask: false, installedOn: nil, versions: [], sizeInBytes: nil))
            }
            packages = searchResultTracker.foundFormulae
        }

        return Section {
                if !isSectionCollapsed {
                    ForEach(packages) { package in
                        SearchResultRow(packageName: package.name, isCask: package.isCask)
                    }
                }
            } header: {
                HStack(alignment: .center) {
                    Text(viewModel.isCask ? "add-package.search.results.casks" : "add-package.search.results.formulae")
                        .animation(.none, value: isSectionCollapsed)
                    Spacer()
                    Button {
                        withAnimation {
                            isSectionCollapsed.toggle()
                        }
                    } label: {
                        Text(isSectionCollapsed ? "action.show" : "action.hide")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Color(nsColor: .controlAccentColor))
                }
            }
    }
}

/*#Preview {
    SearchResultsSection()
}*/
