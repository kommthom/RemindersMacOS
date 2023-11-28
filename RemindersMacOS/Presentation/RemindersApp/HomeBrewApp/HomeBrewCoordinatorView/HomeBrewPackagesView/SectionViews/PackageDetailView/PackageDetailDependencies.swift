//
//  PackageDetailDependencies.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageDetailDependencies: View {
    @AppStorage("displayAdvancedDependencies") var displayAdvancedDependencies: Bool = false
    @AppStorage("showSearchFieldForDependenciesInPackageDetails") var showSearchFieldForDependenciesInPackageDetails: Bool = false
    @State var dependencies: [BrewPackageDependency]
    @State private var isShowingDependencies: Bool = false
    @State private var dependencySearchText: String = ""
    var foundDependencies: [BrewPackageDependency]
    {
        dependencySearchText.isEmpty ? dependencies : dependencies.filter({ $0.name.localizedCaseInsensitiveContains(dependencySearchText) })
    }
    
    var body: some View {
        GroupBox {
            VStack {
                DisclosureGroup("package-details.dependencies", isExpanded: $isShowingDependencies) {}
                    .disclosureGroupStyle(NoPadding())
                if isShowingDependencies {
                    VStack(alignment: .leading, spacing: 5) {
                        if showSearchFieldForDependenciesInPackageDetails {
                            CustomSearchField(search: $dependencySearchText, customPromptText: "package-details.dependencies.search.prompt")
                        }
                        if displayAdvancedDependencies {
                            Table(foundDependencies) {
                                TableColumn("package-details.dependencies.results.name") { dependency in
                                    Text(dependency.name)
                                }
                                TableColumn("package-details.dependencies.results.version") { dependency in
                                    Text(dependency.version)
                                }
                                TableColumn("package-details.dependencies.results.declaration") { dependency in
                                    dependency.directlyDeclared ? Text("package-details.dependencies.results.declaration.direct") : Text("package-details.dependencies.results.declaration.indirect")
                                }
                            }
                            .tableStyle(.bordered)
                            .frame(height: 100)
                        } else {
                                List(foundDependencies) { dependency in
                                    Text(dependency.name)
                                }
                                .listStyle(.bordered(alternatesRowBackgrounds: true))
                                .frame(height: 100)
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
    PackageDetailDependencies()
}*/
