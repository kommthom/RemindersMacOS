//
//  PackageListItem.swift
//  RemindersMacOS
//
//  Created by Thomas on 28.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageListItem: View {
    @EnvironmentObject var homeBrewState: HomeBrewState
    @EnvironmentObject var brewData: BrewDataStorage
    var package: BrewPackage
    var body: some View {
        HStack {
            HStack(alignment: .firstTextBaseline) {
                if package.isBeingModified {
                    switch homeBrewState.actionSuccess {
                    case .notRequested:
                        PackageListItemView(packageIsTagged: package.isTagged, packageName: package.name) {
                            packageVersionsView(package.versions)
                        }
                    case .isExecuting(_, _):
                        PackageListItemView(packageIsTagged: package.isTagged, packageName: package.name) {
                            packageVersionsView(package.versions)
                            Spacer()
                            ProgressView()
                                .frame(height: 5)
                                .scaleEffect(0.5)
                        }
                    case .executed(_):
                        uninstallPackageExecutedView(packageName: package.name, isCask: package.isCask)
                    case .failed(_):
                        let _ = brewData.setHasErrorStatus(withName: package.name, tracker: package.isCask ? .cask : .formula)
                        PackageListItemView(packageIsTagged: package.isTagged, packageName: package.name) {
                            packageVersionsView(package.versions)
                            Spacer()
                            Image(systemName: "alert")
                        }
                    }
                } else if package.hasError {
                    PackageListItemView(packageIsTagged: package.isTagged, packageName: package.name) {
                        packageVersionsView(package.versions)
                        Spacer()
                        Image(systemName: "alert")
                    }
                } else {
                    PackageListItemView(packageIsTagged: package.isTagged, packageName: package.name) {
                        packageVersionsView(package.versions)
                    }
                }
            }
            #if hasAttribute(bouncy)
                .animation(.bouncy, value: package.isTagged)
            #else
                .animation(.interpolatingSpring(stiffness: 80, damping: 10), value: package.isTagged)
            #endif
        }
    }
    
    func packageVersionsView(_ packageVersions: [String]) -> some View {
        Text(packageVersions.formatted(.list(type: .and, width: .narrow)))
            .font(.subheadline)
            .foregroundColor(.secondary)
            .layoutPriority(-Double(2))
    }
    
    func uninstallPackageExecutedView(packageName: String, isCask: Bool) -> some View {
        Delay(1).performWork {
            if isCask {
                brewData.removeCaskFromTracker(withName: packageName)
            } else {
                brewData.removeFormulaFromTracker(withName: packageName)
            }
            homeBrewState.actionSuccess = .notRequested
        }
        return PackageListItemView(packageIsTagged: package.isTagged, packageName: package.name) {
            packageVersionsView(package.versions)
        }
    }
}

struct PackageListItemView<Content: View>: View {
    let packageIsTagged: Bool
    let packageName: String
    @ViewBuilder var content: Content
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            if packageIsTagged {
                Circle()
                    .frame(width: 10, height: 10, alignment: .center)
                    .foregroundStyle(.blue)
                    .transition(.scale)
            }
            SanitizedPackageName(packageName: packageName, shouldShowVersion: false)
        }
        content
    }
}

#Preview {
    PackageListItem(package: BrewPackage.mockedData[0])
}
