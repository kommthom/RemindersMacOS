//
//  TopPackagesSection.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import SwiftUI
import Reminders_Domain

struct TopPackagesSection: View {
    @StateObject var viewModel: TopPackagesViewModel
    @AppStorage("discoverabilityDaySpan") var discoverabilityDaySpan: DiscoverabilityDaySpans = .month
    @AppStorage("sortTopPackagesBy") var sortTopPackagesBy: TopPackageSorting = .mostDownloads
    @EnvironmentObject var brewData: BrewDataStorage
    @EnvironmentObject var topPackagesTracker: TopPackagesTracker
    let isCaskTracker: Bool

    @State private var isCollapsed: Bool = false

    var body: some View {
        switch viewModel.topPackages {
        case .notRequested:
            notRequestedTopPackagesView
        case .isLoading(let last, _):
            loadingTopPackagesView(last)
                .frame(minHeight: 200)
        case .loaded(let topPackages):
            loadedTopPackagesView(topPackages)
        case .failed(let error):
            failedTopPackagesView(error)
        }
    }
    
    var notRequestedTopPackagesView: some View {
        Text("").onAppear(perform: { viewModel.load(numberOfDays: discoverabilityDaySpan.rawValue) } )
    }
    
    func loadingTopPackagesView(_ previouslyLoaded: [TopPackage]?) -> some View {
        if let topPackages = previouslyLoaded {
            return AnyView(loadedTopPackagesView(topPackages))
        } else {
            return AnyView(ProgressView("Loading top packages…").padding())
        }
    }
    
    func failedTopPackagesView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: { viewModel.load(numberOfDays: discoverabilityDaySpan.rawValue) } )
    }
    
    func loadedTopPackagesView( _ topPackages: [TopPackage]) -> some View {
        if isCaskTracker {
            topPackagesTracker.topCasks = topPackages.sorted(by: sortTopPackagesBy.sortComparator)
        } else {
            topPackagesTracker.topFormulae = topPackages.sorted(by: sortTopPackagesBy.sortComparator)
        }
        return Section {
            if !isCollapsed {
                if isCaskTracker {
                    ForEach(topPackagesTracker.topCasks.filter {
                        !brewData.installedFormulae.map(\.name).contains($0.packageName)
                    }.prefix(15)) { topCask in
                        HStack(alignment: .center) {
                            SanitizedPackageName(packageName: topCask.packageName, shouldShowVersion: true)
                            Spacer()
                            Text("add-package.top-packages.list-item-\(topCask.packageDownloads)")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                } else {
                    ForEach(topPackagesTracker.topFormulae.filter {
                        !brewData.installedCasks.map(\.name).contains($0.packageName)
                    }
                        .prefix(15)) { topFormula in
                            HStack(alignment: .center) {
                                SanitizedPackageName(packageName: topFormula.packageName, shouldShowVersion: true)
                                Spacer()
                                Text("add-package.top-packages.list-item-\(topFormula.packageDownloads)")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                }
            }
        } header: {
            HStack(alignment: .center) {
                Text(isCaskTracker ? "add-package.top-casks" : "add-package.top-formulae")
                    .animation(.none, value: isCollapsed)
                Spacer()
                Button {
                    withAnimation {
                        isCollapsed.toggle()
                    }
                } label: {
                    Text(isCollapsed ? "action.show" : "action.hide")
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color(nsColor: .controlAccentColor))
            }
        }
    }
}

/*#Preview {
    TopPackagesSection(isCaskTracker: false)
}*/
