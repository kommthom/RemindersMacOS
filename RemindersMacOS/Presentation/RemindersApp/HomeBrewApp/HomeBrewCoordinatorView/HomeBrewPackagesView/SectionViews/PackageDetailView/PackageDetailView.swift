//
//  PackageDetailView.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageDetailView: View {
    @AppStorage("caveatDisplayOptions") var caveatDisplayOptions: PackageCaveatDisplay = .full
    @StateObject var viewModel: PackageDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                PackageDetailHeaderView(packageName: viewModel.brewPackageName, versions: viewModel.versions, pinned: viewModel.state.pinned ?? false)
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center, spacing: 5) {
                        if viewModel.state.installedAsDependency ?? false {
                            PackageDetailInstalledAsDependency(packageDependents: viewModel.state.packageDependents)
                        }
                        if viewModel.state.outdated ?? false {
                            Text("package-details.outdated")
                                .font(.caption2)
                                .padding(.horizontal, 4)
                                .foregroundColor(.orange)
                                .overlay(Capsule().stroke(.orange, lineWidth: 1))
                        }
                        if let _ = viewModel.state.caveats {
                            PackageDetailCaveatsMini(caveats: viewModel.state.caveats ?? "", caveatDisplayOptions: caveatDisplayOptions)
                        }
                    }
                    PackageDetailDescription(description: viewModel.state.description ?? "description", packageName: viewModel.brewPackageName)
                }
            }
            switch viewModel.state.homeBrewPackageInfo {
            case .notRequested:
                Text("").onAppear (perform: viewModel.loadPackageInfo )
            case .isLoading(_, _):
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        ProgressView {
                            Text("package-details.contents.loading")
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            case let .loaded(selectedPackageInfo):
                loadedPackageInfoView(selectedPackageInfo)
            case let .failed(error):
                ErrorView(error: error, retryAction: viewModel.loadPackageInfo )
            }
            Spacer()
            if let _ = viewModel.installedOn, let _ = viewModel.state.description { // Only show the uninstall button for packages that are actually installed
                PackageDetailButtons(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
    
    func loadedPackageInfoView(_ homeBrewPackageInfo: BrewPackageInfo) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            Text("package-details.info")
                .font(.title2)
            if let _ = viewModel.state.caveats {
                PackageDetailCaveatsFull(caveats: viewModel.state.caveats ?? "", caveatDisplayOptions: caveatDisplayOptions)
            }
            PackageDetailTapTypeHomepage(tap: viewModel.state.tap ?? "", isCask: viewModel.isCask, homepage: viewModel.state.homePage ?? URL(fileURLWithPath: "https://google.com"))
            if let _ = viewModel.state.dependencies {
                PackageDetailDependencies(dependencies: viewModel.state.dependencies!)
            }
            if let _ = viewModel.installedOn { // Only show the "Installed on" date for packages that are actually installed
                PackageDetailInstalledOn(installedOnDate: viewModel.installedOn!, sizeInBytes: viewModel.sizeInBytes, isCask: viewModel.isCask)
            }
        }
    }
}


/*#Preview {
    PackageDetailView()
}*/
