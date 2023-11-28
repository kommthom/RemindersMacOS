//
//  OutdatedPackagesView.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import SwiftUI
import Reminders_Brew
import Reminders_Domain

struct OutdatedPackagesView: View {
    @StateObject var homeBrewMainVM: HomeBrewMainViewModel
    @Binding var isDropdownExpanded: Bool
    var onButtonTapped: ( _ buttonTapped: ButtonTapped) -> Void
    
    private var packagesMarkedForUpdating: Set<OutdatedPackage> {
        return homeBrewMainVM.brewData.outdatedPackages.filter({ $0.isMarkedForUpdating })
    }
    
    var body: some View {
        GroupBox {
            Grid {
                GridRow(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: homeBrewMainVM.brewData.outdatedPackages.count == 1 ? "square.and.arrow.down" : "square.and.arrow.down.on.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 26, height: 26)
                            VStack(alignment: .leading, spacing: 5) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("start-page.updates.count-\(homeBrewMainVM.brewData.outdatedPackages.count)")
                                        .font(.headline)
                                    Spacer()
                                    if packagesMarkedForUpdating.count == homeBrewMainVM.brewData.outdatedPackages.count {
                                        Button {
                                            onButtonTapped(.updateAll)
                                        } label: {
                                            Text("start-page.updates.action")
                                        }
                                    } else {
                                        Button {
                                            onButtonTapped(.incrementalUpdate)
                                        } label: {
                                            Text("start-page.update-incremental.package-count-\(packagesMarkedForUpdating.count)")
                                        }
                                        .disabled(packagesMarkedForUpdating.count == 0)
                                    }
                                }
                                DisclosureGroup(isExpanded: $isDropdownExpanded) {
                                    List {
                                        Section  {
                                            ForEach(homeBrewMainVM.brewData.outdatedPackages.sorted(by: { $0.package.installedOn! < $1.package.installedOn! })) { outdatedPackage in
                                                Toggle(isOn: Binding<Bool>(
                                                    get: {
                                                        outdatedPackage.isMarkedForUpdating
                                                    }, set: { toggleState in
                                                        homeBrewMainVM.brewData.toggleIsMarkedForUpdating(withId: outdatedPackage.id, toggleState: toggleState)
                                                    }
                                                )) {
                                                    SanitizedPackageName(packageName: outdatedPackage.package.name, shouldShowVersion: true)
                                                }
                                            }
                                        } header: {
                                            HStack(alignment: .center, spacing: 10) {
                                                Button {
                                                    homeBrewMainVM.brewData.toggleIsMarkedForUpdating(withId: nil, toggleState: false)
                                                } label: {
                                                    Text("start-page.updated.action.deselect-all")
                                                }
                                                .buttonStyle(.plain)
                                                .disabled(packagesMarkedForUpdating.count == 0)
                                                Button {
                                                    homeBrewMainVM.brewData.toggleIsMarkedForUpdating(withId: nil, toggleState: true)
                                                } label: {
                                                    Text("start-page.updated.action.select-all")
                                                }
                                                .buttonStyle(.plain)
                                                .disabled(packagesMarkedForUpdating.count == homeBrewMainVM.brewData.outdatedPackages.count)
                                            }
                                        }
                                    }
                                    .listStyle(.bordered(alternatesRowBackgrounds: true))
                                } label: {
                                    Text("start-page.updates.list")
                                        .font(.subheadline)
                                }
                                .disclosureGroupStyle(NoPadding())
                            }
                        }
                        .padding(7)
                    }
                }
            }
        }
    }
}

/*#Preview {
    OutdatedPackagesView()
}*/
